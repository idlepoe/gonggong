import {onSchedule} from "firebase-functions/v2/scheduler";
import {logger, setGlobalOptions} from "firebase-functions";
import axios from "axios";
import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/https";

admin.initializeApp();
setGlobalOptions({region: "asia-northeast3"});

export const scheduledFetchAndResolveBets = onSchedule("20 * * * *", async () => {
    try {
        // ① 수온 데이터 수집 및 저장
        await fetchWaterData(); // ✅ docId + data 반환
    } catch (e) {
        logger.error("📛 scheduledFetchAndResolveBets 실패", e);
    }
});


export const fetchWaterSnapshot = onRequest(async (req, res) => {
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

export const syncSeoulMuseumGachaManual = onRequest(async (req, res) => {
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

    const siteSlugMap: Record<string, string> = {
        "탄천": "tancheon",
        "중랑천": "jungnang",
        "안양천": "anyang",
        "한강": "hangang",
        "선유": "sunyu",
    };

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
        const endDate = new Date(startDate.getTime() + 80 * 60 * 1000);

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


export const placeBet = onRequest(async (req, res) => {
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

        // ✅ 취소 처리
        if (cancel === true) {
            await db.runTransaction(async (tx) => {
                const betSnap = await tx.get(betRef);
                const userSnap = await tx.get(userRef);

                if (!betSnap.exists) throw new Error("❌ 베팅 정보 없음");

                const bet = betSnap.data()!;
                const refundAmount = Math.floor(bet.amount * 0.85);
                const currentPoints = userSnap.data()?.points ?? 0;

                const marketRef = db.collection("measurements").doc(`${site_id}_${type_id}`);

                // 🔹 포인트 환불
                tx.update(userRef, {
                    points: currentPoints + refundAmount,
                });

                // 🔹 베팅 삭제
                tx.delete(betRef);

                // ✅ 🔹 measurements.updatedAt 갱신
                tx.update(marketRef, {
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
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
            const currentPoints = userSnap.data()?.points ?? 0;

            if (currentPoints < amount) {
                throw new Error("❌ 포인트 부족");
            }

            const userData = userSnap.data();
            const userName = userData?.name ?? "";
            const avatarUrl = userData?.avatarUrl ?? "";

            const marketRef = db.collection("measurements").doc(`${site_id}_${type_id}`);
            const marketSnap = await tx.get(marketRef);
            const question = marketSnap.data()?.question ?? "";

            // 포인트 차감
            tx.update(userRef, {
                points: currentPoints - amount,
            });

            // 베팅 정보 저장
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

            // ✅ 🔹 measurements.updatedAt 갱신
            tx.update(marketRef, {
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
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

    // 사용자별 결과 모음
    const resultsByUser: { [uid: string]: string[] } = {};

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

        // 사용자별 결과 축적
        const resultLine = won
            ? `✅ ${bet.question} - ${bet.amount}P → ${reward}P`
            : `❌ ${bet.question} - ${bet.amount}P 실패`;

        if (!resultsByUser[bet.uid]) resultsByUser[bet.uid] = [];
        resultsByUser[bet.uid].push(resultLine);
    }

    await batch.commit();
    console.log(`✅ ${site_id}_${type_id} 베팅 정산 완료 (${isUp ? '상승' : '하락'})`);

    // ✅ 사용자별 푸시 메시지 전송
    for (const [uid, resultLines] of Object.entries(resultsByUser)) {
        try {
            await admin.messaging().send({
                topic: `user_${uid}`,
                notification: {
                    title: '📊 베팅 결과가 도착했어요!',
                    body: `총 ${resultLines.length}건의 결과를 확인해보세요.`,
                },
                data: {
                    resultLines: resultLines.join('\n'),  // 최대 길이 고려
                    site_id,
                    type_id,
                    resultCount: resultLines.length.toString(),
                },
            });

            console.log(
                `📬 푸시 전송 완료 → uid: ${uid}, 총 ${resultLines.length}건 요약 발송`
            );
        } catch (error) {
            console.error(
                `❗️푸시 전송 실패 (uid: ${uid}):`,
                (error as Error).message
            );
        }
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

export const purchaseRandomArtwork = onRequest(async (req, res) => {
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

        const result = await db.runTransaction(async (tx) => {
            const userRef = db.collection('users').doc(uid);
            const userSnap = await tx.get(userRef);
            const userData: any = userSnap.data();

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
            res.status(401).json({ error: 'Unauthorized: Missing auth token' });
            return;
        }

        const decoded = await admin.auth().verifyIdToken(authToken);
        const uid = decoded.uid;

        const { artworkId } = req.body;
        if (!artworkId) {
            res.status(400).json({ error: 'artworkId는 필수입니다.' });
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
            res.status(404).json({ error: '유저 정보가 없습니다.' });
            return;
        }

        if (!artworkSnap.exists) {
            res.status(404).json({ error: '작품 정보가 없습니다.' });
            return;
        }

        if (ownedSnap.exists) {
            res.status(409).json({ error: '이미 소장한 작품입니다.' });
            return;
        }

        const userData = userSnap.data()!;
        const artworkData = artworkSnap.data()!;
        const userPoints = userData.points ?? 0;
        const price = artworkData.price ?? 800;

        if (userPoints < price) {
            res.status(400).json({ error: '포인트가 부족합니다.' });
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

        res.status(200).json({
            success: true,
            newPoints: userPoints - price,
            message: '작품을 성공적으로 소장했습니다.',
        });
    } catch (error) {
        console.error('🔥 Error purchasing artwork:', error);
        res.status(500).json({ error: '서버 오류가 발생했습니다.' });
    }
});
