import {onSchedule} from "firebase-functions/v2/scheduler";
import {logger, setGlobalOptions} from "firebase-functions";
import axios from "axios";
import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/https";

admin.initializeApp();
setGlobalOptions({region: "asia-northeast3"});

const siteSlugMap: Record<string, string> = {
    "탄천": "tancheon",
    "중랑천": "jungnang",
    "안양천": "anyang",
    "한강": "hangang",
    "선유": "sunyu",
};

export const scheduledFetchAndResolveBets = onSchedule("25 * * * *", async () => {
    try {
        // 수온 데이터 수집 및 저장
        await fetchWaterData();
        // 미세 먼지 데이터 수집 및 저장
        await fetchDustLevel();

        await sendBetPushManually();
    } catch (e) {
        logger.error("📛 scheduledFetchAndResolveBets 실패", e);
    }
});


export const fetchWaterManual = onRequest({
    cors: true,
    region: "asia-northeast3",
}, async (req, res) => {
    try {
        // ① 수온 데이터 수집 및 저장
        await fetchWaterData(); // ✅ docId + data 반환
        res.status(200).json({
            success: true,
            message: "✅ 수온 데이터 저장 완료",
        });
    } catch (e: any) {
        console.error("📛 fetchWaterSnapshot 실패", e);
        res.status(500).json({
            success: false,
            message: e.message ?? "알 수 없는 오류",
        });
    }
});

export const fetchDustLevelManual = onRequest({
    cors: true,
    region: "asia-northeast3",
}, async (req, res) => {
    try {
        // ① 미세먼지 데이터 수집 및 저장
        await fetchDustLevel(); // ✅ docId + data 반환
        res.status(200).json({
            success: true,
            message: "✅ 미세먼지 데이터 저장 완료",
        });
    } catch (e: any) {
        console.error("📛 fetchDustLevelManual 실패", e);
        res.status(500).json({
            success: false,
            message: e.message ?? "알 수 없는 오류",
        });
    }
});

export const syncSeoulMuseumGachaManual = onRequest({
    cors: true,
    region: "asia-northeast3",
}, async (req, res) => {
    try {
        await performSeoulMuseumGachaSync();
        res.status(200).send("✅ 수동 동기화 완료");
    } catch (error) {
        console.error("❌ 수동 동기화 실패:", error);
        res.status(500).send("동기화 실패");
    }
});

export async function fetchWaterData(): Promise<void> {
    const API_KEY = "53574b6e7069646c3631646b4a4e53";
    const url = `http://openapi.seoul.go.kr:8088/${API_KEY}/json/WPOSInformationTime/1/10`;

    const response = await axios.get(url);
    const rows = response.data?.WPOSInformationTime?.row ?? [];

    const now = new Date(Date.now() + 9 * 60 * 60 * 1000); // KST
    now.setMinutes(0, 0, 0);
    const targetHour = now.getHours();
    const targetHourStr = targetHour === 0 ? "24:00" : `${targetHour.toString().padStart(2, "0")}:00`;

    const filtered = rows.filter(
        (row: any) => row.MSR_TIME === targetHourStr && parseFloat(row.W_TEMP) > 0,
    );

    if (filtered.length === 0) throw new Error(`${targetHourStr} 시각의 데이터 없음`);

    const type_id = "water_temp";
    const type_name = "수온";
    const unit = "°C";
    const interval = "1시간";

    const db = admin.firestore();
    const batch = db.batch();

    for (const row of filtered) {
        const name = row.SITE_ID;
        const site_id = siteSlugMap[name] ?? name.replace(/\s+/g, "_").toLowerCase();
        const value = parseFloat(row.W_TEMP);

        const startDate = new Date(
            `${row.MSR_DATE.slice(0, 4)}-${row.MSR_DATE.slice(4, 6)}-${row.MSR_DATE.slice(6, 8)}T${row.MSR_TIME}:00+09:00`
        );
        const endDate = new Date(startDate.getTime() + 85 * 60 * 1000);

        const parentDocId = `${site_id}_${type_id}`;
        const valueDocId = `${row.MSR_DATE}${row.MSR_TIME.replace(":", "")}`;
        const question = `한 시간 뒤 ${name}의 수온은 오를까?`;

        const parentRef = db.collection("measurements").doc(parentDocId);
        const valueRef = parentRef.collection("values").doc(valueDocId);

        // ✅ 이전 값 가져오기
        const prevSnap = await parentRef
            .collection("values")
            .orderBy("startDate", "desc")
            .limit(1)
            .get();

        if (!prevSnap.empty) {
            const prevValue = prevSnap.docs[0].data().value;

            // ✅ 정산 실행
            await settleBets({
                site_id,
                type_id,
                previousValue: prevValue,
                currentValue: value,
            });
        }

        // ✅ Firestore 저장
        batch.set(parentRef, {
            site_id,
            site_name: name,
            type_id,
            type_name,
            unit,
            question,
            interval,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true});

        batch.set(valueRef, {
            name,
            value,
            startDate,
            endDate,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }

    await batch.commit();
    console.log(`✅ ${filtered.length}개의 수온 데이터 저장 및 정산 완료`);
}

export async function fetchDustLevel(): Promise<void> {
    const API_KEY = "53574b6e7069646c3631646b4a4e53";
    const url = `http://openapi.seoul.go.kr:8088/${API_KEY}/json/ListAirQualityByDistrictService/1/25`;

    const response = await axios.get(url);
    const rows = response.data?.ListAirQualityByDistrictService?.row ?? [];

    const now = new Date(Date.now() + 9 * 60 * 60 * 1000); // KST
    now.setMinutes(0, 0, 0);
    const msrDate = `${now.getFullYear()}${(now.getMonth() + 1).toString().padStart(2, "0")}${now.getDate().toString().padStart(2, "0")}`;
    const msrHour = `${now.getHours().toString().padStart(2, "0")}00`;
    const msrDateTime = `${msrDate}${msrHour}`;

    const filtered = rows.filter(
        (row: any) =>
            row.MSRDATE === msrDateTime &&
            parseFloat(row.PM10) > 0
    );

    if (filtered.length === 0) throw new Error(`${msrDateTime} 시각의 미세먼지 데이터 없음`);

    const type_id = "dust_level";
    const type_name = "미세먼지농도";
    const unit = "㎍/㎥";
    const interval = "1시간";

    const db = admin.firestore();
    const batch = db.batch();

    for (const row of filtered) {
        const site_id = row.MSRADMCODE;
        const site_name = row.MSRSTENAME;
        const value = parseFloat(row.PM10);

        const startDate = new Date(`${row.MSRDATE.slice(0, 4)}-${row.MSRDATE.slice(4, 6)}-${row.MSRDATE.slice(6, 8)}T${row.MSRDATE.slice(8, 10)}:00:00+09:00`);
        const endDate = new Date(startDate.getTime() + 85 * 60 * 1000);

        const parentDocId = `${site_id}_${type_id}`;
        const valueDocId = row.MSRDATE;
        const question = `한 시간 뒤 ${site_name}의 미세먼지 농도는 높아질까?`;

        const parentRef = db.collection("measurements").doc(parentDocId);
        const valueRef = parentRef.collection("values").doc(valueDocId);

        // ✅ 이전 값 가져오기
        const prevSnap = await parentRef
            .collection("values")
            .orderBy("startDate", "desc")
            .limit(1)
            .get();

        if (!prevSnap.empty) {
            const prevValue = prevSnap.docs[0].data().value;

            // ✅ 정산 실행
            await settleBets({
                site_id,
                type_id,
                previousValue: prevValue,
                currentValue: value,
            });
        }

        // ✅ Firestore 저장
        batch.set(parentRef, {
            site_id,
            site_name,
            type_id,
            type_name,
            unit,
            question,
            interval,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true});

        batch.set(valueRef, {
            name: site_name,
            value,
            startDate,
            endDate,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }

    await batch.commit();
    console.log(`✅ ${filtered.length}개의 미세먼지 데이터 저장 및 정산 완료`);
}

export const placeBet = onRequest({
    cors: true,
    region: "asia-northeast3",
}, async (req, res) => {
    try {
        const {
            uid,
            site_id,
            type_id,
            amount,
            direction, // 'up' or 'down'
            odds,
            cancel = false,
        } = req.body;

        if (!uid || !site_id || !type_id) {
            res.status(400).send("❌ 필수 파라미터 누락");
            return;
        }

        const db = admin.firestore();
        const userRef = db.collection("users").doc(uid);
        const betRef = db
            .collection("bets")
            .doc(`${site_id}_${type_id}`)
            .collection("entries")
            .doc(uid);

        let userName = '';
        let avatarUrl = '';
        let bet: any = null;
        let refundAmount = 0;
        let question = '';

        // ✅ 취소 처리
        if (cancel) {
            await db.runTransaction(async (tx) => {
                const betSnap = await tx.get(betRef);
                const userSnap = await tx.get(userRef);
                const userData = userSnap.data();
                userName = userData?.name ?? "";
                avatarUrl = userData?.avatarUrl ?? "";

                if (!betSnap.exists) throw new Error("❌ 베팅 정보 없음");

                bet = betSnap.data()!;
                refundAmount = Math.floor(bet.amount * 0.85);
                const currentPoints = userSnap.data()?.points ?? 0;

                const marketRef = db.collection("measurements").doc(`${site_id}_${type_id}`);
                const summaryRef = db
                    .collection("bets")
                    .doc(`${site_id}_${type_id}`)
                    .collection("summary")
                    .doc("totals");

                const summarySnap = await tx.get(summaryRef);
                if (!summarySnap.exists) throw new Error("❌ summary 정보 없음");

                const isUp = bet.direction === "up";
                const fieldToDecrement = isUp ? "totalUpAmount" : "totalDownAmount";

                // 🔹 유저 포인트 환불
                tx.update(userRef, {
                    points: currentPoints + refundAmount,
                });

                // 🔹 베팅 삭제
                tx.delete(betRef);

                // 🔹 measurements.updatedAt 갱신
                tx.update(marketRef, {
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });

                // 🔹 summary에서 금액 차감
                tx.update(summaryRef, {
                    [fieldToDecrement]: admin.firestore.FieldValue.increment(-bet.amount),
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            });

            await db.collection('activity').add({
                type: 'cancel',
                uid,
                name: userName,
                avatarUrl,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                message: `🌀 ${bet.question}\n❎ <point>${bet.amount}P</point> 베팅 취소 → <point>${refundAmount}P</point> 환불`,
            });

            res.status(200).send("🪙 베팅 취소 완료 (15% 수수료 제외)");
            return;
        }

        // ✅ 유효성 검사
        if (
            typeof amount !== "number" ||
            typeof odds !== "number" ||
            !["up", "down"].includes(direction)
        ) {
            res.status(400).send("❌ 베팅 파라미터 오류");
            return;
        }

        await db.runTransaction(async (tx) => {
            const userSnap = await tx.get(userRef);
            const marketRef = db.collection("measurements").doc(`${site_id}_${type_id}`);
            const marketSnap = await tx.get(marketRef);
            const summaryRef = db
                .collection("bets")
                .doc(`${site_id}_${type_id}`)
                .collection("summary")
                .doc("totals");
            const summarySnap = await tx.get(summaryRef); // ⬅️ get 먼저!

            const currentPoints = userSnap.data()?.points ?? 0;
            if (currentPoints < amount) {
                throw new Error("❌ 포인트 부족");
            }

            const userData = userSnap.data();
            userName = userData?.name ?? "";
            avatarUrl = userData?.avatarUrl ?? "";
            question = marketSnap.data()?.question ?? "";

            const isUp = direction === "up";
            const fieldToIncrement = isUp ? "totalUpAmount" : "totalDownAmount";

            // 🔹 포인트 차감
            tx.update(userRef, {
                points: currentPoints - amount,
            });

            // 🔹 베팅 저장
            tx.set(betRef, {
                uid,
                site_id,
                type_id,
                direction,
                amount,
                odds,
                userName,
                avatarUrl,
                question,
                isCancelled: false,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            // 🔹 measurements.updatedAt 갱신
            tx.update(marketRef, {
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            // 🔹 summary 업데이트
            if (!summarySnap.exists) {
                tx.set(summaryRef, {
                    totalUpAmount: isUp ? amount : 0,
                    totalDownAmount: isUp ? 0 : amount,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            } else {
                tx.update(summaryRef, {
                    [fieldToIncrement]: admin.firestore.FieldValue.increment(amount),
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            }
        });

        // ⬇️ 트랜잭션 이후 활동 로그 작성
        await db.collection("activity").add({
            type: "bet",
            uid,
            name: userName,
            avatarUrl,
            site_id,
            type_id,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            message: `🌀 ${question}\n🎯 <point>${amount}P</point> 베팅 → <${direction === 'up' ? 'dir_up' : 'dir_down'}>${direction === 'up' ? '상승' : '하락'}</${direction === 'up' ? 'dir_up' : 'dir_down'}> 예측`,
        });

        res.status(200).send("✅ 베팅 성공");
    } catch (error: any) {
        console.error("❌ placeBet 실패:", error);
        res.status(500).send(`❌ ${error.message}`);
    }
});

export async function settleBets({
                                     site_id,
                                     type_id,
                                     previousValue,
                                     currentValue,
                                 }: {
    site_id: string;
    type_id: string;
    previousValue: number;
    currentValue: number;
}) {
    const db = admin.firestore();
    const betColl = db.collection('bets').doc(`${site_id}_${type_id}`).collection('entries');
    const betSnap = await betColl.get();

    const batch = db.batch();
    const isUp = currentValue > previousValue;

    for (const doc of betSnap.docs) {
        const bet = doc.data();
        const userRef = db.collection('users').doc(bet.uid);
        const won = bet.direction === (isUp ? 'up' : 'down');
        const reward = Math.floor(bet.amount * bet.odds);

        if (won) {
            batch.update(userRef, {
                points: admin.firestore.FieldValue.increment(reward),
            });
        }

        // 기록용 백업
        const historyRef = db.collection('bets_history').doc();
        batch.set(historyRef, {
            ...bet,
            result: won ? 'win' : 'lose',
            settledAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // 기존 베팅 제거
        batch.delete(doc.ref);

        if (won) {
            batch.update(userRef, {
                points: admin.firestore.FieldValue.increment(reward),
            });
        }
    }

    await batch.commit();
    console.log(`✅ ${site_id}_${type_id} 베팅 정산 완료 (${isUp ? '상승' : '하락'})`);

    // ✅ summary 값만 초기화
    const summaryRef = db
        .collection("bets")
        .doc(`${site_id}_${type_id}`)
        .collection("summary")
        .doc("totals");

    try {
        await summaryRef.set({
            totalUpAmount: 0,
            totalDownAmount: 0,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true}); // 문서가 있으면 유지, 없으면 생성
        console.log(`🧹 summary 값 초기화 완료: ${site_id}_${type_id}`);
    } catch (e) {
        console.error(`❗ summary 초기화 실패:`, (e as Error).message);
    }
}

export const syncSeoulMuseumGacha = onSchedule(
    {
        schedule: "0 9 1 * *", // 매월 1일 오전 9시
        timeZone: "Asia/Seoul",
    },
    async () => {
        await performSeoulMuseumGachaSync();
    }
);

async function performSeoulMuseumGachaSync() {
    const db = admin.firestore();

    const API_KEY = '53574b6e7069646c3631646b4a4e53';
    const API_BASE = `http://openapi.seoul.go.kr:8088/${API_KEY}/json/SemaPsgudInfoKorInfo`;
    const BATCH_SIZE = 1000;

    try {
        // 전체 개수 조회
        const totalRes = await axios.get(`${API_BASE}/1/1`);
        const totalCount = totalRes.data.SemaPsgudInfoKorInfo.list_total_count;
        const pages = Math.ceil(totalCount / BATCH_SIZE);
        console.log(`🎨 총 작품 수: ${totalCount}, 페이지 수: ${pages}`);

        for (let i = 0; i < pages; i++) {
            const start = i * BATCH_SIZE + 1;
            const end = Math.min((i + 1) * BATCH_SIZE, totalCount);

            const url = `${API_BASE}/${start}/${end}`;
            console.log(`📦 요청 중: ${url}`);

            const response = await axios.get(url);
            const rows = response.data.SemaPsgudInfoKorInfo.row;

            if (!rows || rows.length === 0) {
                console.log(`⚠️ ${start} ~ ${end} 데이터 없음`);
                continue;
            }

            const batch = db.batch();
            for (const item of rows) {
                const id = `${item.manage_no_year ?? 'unknown'}_${item.prdct_nm_korean ?? 'unknown'}`
                    .replace(/ /g, '_');
                const docRef = db.collection('artworks').doc(id);
                const price = calculateArtworkPrice(item);

                batch.set(docRef, {
                    ...item,
                    price: price,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                }, {merge: true});
            }

            await batch.commit();
            console.log(`✅ 저장 완료: ${start} ~ ${end}`);
        }

        console.log('🎉 서울시립미술관 작품 전체 동기화 완료!');
    } catch (error) {
        console.error('❌ 동기화 실패:', (error as Error).message);
    }
}

export const purchaseRandomArtwork = onRequest({
    cors: true,
    region: "asia-northeast3",
}, async (req, res) => {
    try {
        const db = admin.firestore();

        const authToken = req.headers.authorization?.split('Bearer ')[1];
        if (!authToken) {
            res.status(401).json({error: 'Unauthorized: Missing auth token'});
            return;
        }

        const decoded = await admin.auth().verifyIdToken(authToken);
        const uid = decoded.uid;

        const POINT_COST = 500;

        let userName = '';
        let avatarUrl = '';

        const result = await db.runTransaction(async (tx) => {
            const userRef = db.collection('users').doc(uid);
            const userSnap = await tx.get(userRef);
            const userData: any = userSnap.data();
            userName = userData?.name ?? "";
            avatarUrl = userData?.avatarUrl ?? "";

            if (!userSnap.exists || (userData?.points ?? 0) < POINT_COST) {
                throw new Error('Insufficient points');
            }

            const artworksSnap = await db.collection('artworks').get();
            const allArtworks = artworksSnap.docs;

            if (allArtworks.length === 0) {
                throw new Error('No artworks available');
            }

            const randomDoc = allArtworks[Math.floor(Math.random() * allArtworks.length)];
            const artworkId = randomDoc.id;
            const artworkData = randomDoc.data();

            const userArtworkRef = userRef.collection('artworks').doc(artworkId);
            const userArtworkSnap = await tx.get(userArtworkRef);

            tx.update(userRef, {
                points: admin.firestore.FieldValue.increment(-POINT_COST),
            });

            if (userArtworkSnap.exists) {
                tx.update(userArtworkRef, {
                    count: admin.firestore.FieldValue.increment(1),
                    lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
                });
            } else {
                tx.set(userArtworkRef, {
                    ownedAt: admin.firestore.FieldValue.serverTimestamp(),
                    count: 1,
                });
            }

            return {
                artworkId,
                artwork: artworkData,
                remainingPoints: userData.points - POINT_COST,
            };
        });

        await db.collection('activity').add({
            type: 'artwork',
            uid,
            name: userName,
            avatarUrl,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            message: `🖼️ <strong>${result.artwork.prdct_nm_korean}</strong> 작품을 소장했어요`,
        });

        res.status(200).json(result);
    } catch (error) {
        console.error('❌ Gacha failed:', (error as Error).message);
        res.status(500).json({error: (error as Error).message});
    }
});

function calculateArtworkPrice(artwork: any): number {
    const input = `${artwork.prdct_nm_korean}_${artwork.writr_nm}_${artwork.mnfct_year}_${artwork.prdct_stndrd}`;
    let hash = 0;
    for (let i = 0; i < input.length; i++) {
        hash = (hash * 31 + input.charCodeAt(i)) >>> 0; // 32bit 안전한 해시
    }
    const min = 800;
    const max = 5000;
    return min + (hash % (max - min));
}

export const purchaseArtwork = onRequest(async (req, res) => {
    try {
        if (req.method !== 'POST') {
            res.status(405).send('Method Not Allowed');
            return;
        }

        const authToken = req.headers.authorization?.split('Bearer ')[1];
        if (!authToken) {
            res.status(401).json({error: 'Unauthorized: Missing auth token'});
            return;
        }

        const decoded = await admin.auth().verifyIdToken(authToken);
        const uid = decoded.uid;

        const {artworkId} = req.body;
        if (!artworkId) {
            res.status(400).json({error: 'artworkId는 필수입니다.'});
            return;
        }

        const db = admin.firestore();
        const userRef = db.collection('users').doc(uid);
        const artworkRef = db.collection('artworks').doc(artworkId);
        const ownedArtworkRef = userRef.collection('artworks').doc(artworkId);

        const [userSnap, artworkSnap, ownedSnap] = await Promise.all([
            userRef.get(),
            artworkRef.get(),
            ownedArtworkRef.get(),
        ]);

        if (!userSnap.exists) {
            res.status(404).json({error: '유저 정보가 없습니다.'});
            return;
        }

        if (!artworkSnap.exists) {
            res.status(404).json({error: '작품 정보가 없습니다.'});
            return;
        }

        if (ownedSnap.exists) {
            res.status(409).json({error: '이미 소장한 작품입니다.'});
            return;
        }

        const userData = userSnap.data()!;
        const userName = userData.name ?? '';
        const avatarUrl = userData.avatarUrl ?? '';
        const artworkData = artworkSnap.data()!;
        const userPoints = userData.points ?? 0;
        const price = artworkData.price ?? 800;

        if (userPoints < price) {
            res.status(400).json({error: '포인트가 부족합니다.'});
            return;
        }

        const batch = db.batch();

        batch.set(ownedArtworkRef, {
            count: 1,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        batch.update(userRef, {
            points: admin.firestore.FieldValue.increment(-price),
        });

        await batch.commit();

        // ✅ 활동 로그 추가
        await db.collection('activity').add({
            type: 'artwork',
            uid,
            name: userName,
            avatarUrl,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            message: `🖼️ <strong>${artworkData.prdct_nm_korean}</strong> 작품을 소장했어요`,
        });

        res.status(200).json({
            success: true,
            newPoints: userPoints - price,
            message: '작품을 성공적으로 소장했습니다.',
        });
    } catch (error) {
        console.error('🔥 Error purchasing artwork:', error);
        res.status(500).json({error: '서버 오류가 발생했습니다.'});
    }
});

async function sendBetPushManually() {
    try {
        const db = admin.firestore();

        const now = admin.firestore.Timestamp.now();
        const fiveMinutesAgo = admin.firestore.Timestamp.fromMillis(now.toMillis() - 5 * 60 * 1000);

        const snap = await db
            .collection("bets_history")
            .where("settledAt", ">=", fiveMinutesAgo)
            .get();

        // 필드 pushed가 true가 아닌 것만 필터링
        const targetDocs = snap.docs.filter(doc => doc.get("pushed") !== true);

        const summaryByUser: {
            [uid: string]: {
                winCount: number;
                loseCount: number;
                totalReward: number;
                totalAmount: number; // ✅ 추가
                docIds: string[];
            };
        } = {};

        for (const doc of targetDocs) {
            const data = doc.data();
            const uid = data.uid;
            const reward = Math.floor((data.amount ?? 0) * (data.odds ?? 0));

            if (!summaryByUser[uid]) {
                summaryByUser[uid] = {
                    winCount: 0,
                    loseCount: 0,
                    totalReward: 0,
                    totalAmount: 0,
                    docIds: [],
                };
            }

            summaryByUser[uid].docIds.push(doc.id);
            summaryByUser[uid].totalAmount += data.amount ?? 0; // ✅ 총 베팅액 누적

            if (data.result === "win") {
                summaryByUser[uid].winCount += 1;
                summaryByUser[uid].totalReward += reward;
            } else {
                summaryByUser[uid].loseCount += 1;
            }
        }

        for (const [uid, summary] of Object.entries(summaryByUser)) {
            const {winCount, loseCount, totalReward, totalAmount, docIds} = summary;

            const summaryLine = `📊 결과 요약\n✅ ${winCount}승  ❌ ${loseCount}패\n💰 획득: ${totalReward}P\n🎯 총 베팅액: ${totalAmount}P`;

            try {
                await admin.messaging().send({
                    topic: `user_${uid}`,
                    notification: {
                        title: "베팅 결과 요약이 도착했어요!",
                        body: summaryLine,
                    },
                    android: {
                        notification: {
                            tag: `bet_result_${uid}_${Date.now()}`,
                        },
                    },
                });

                // pushed: true 마킹
                const batch = db.batch();
                for (const docId of docIds) {
                    const ref = db.collection("bets_history").doc(docId);
                    batch.update(ref, {pushed: true});
                }
                await batch.commit();

                console.log(`📬 푸시 전송 완료 → uid: ${uid}`);
            } catch (err) {
                console.error(`❌ 푸시 전송 실패 → uid: ${uid}`, (err as Error).message);
            }
        }
    } catch (error) {
        console.error("❗️푸시 전송 처리 중 에러 발생:", (error as Error).message);
    }
}
