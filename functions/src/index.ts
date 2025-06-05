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

        logger.info(`✅ 기준 베팅 생성`);

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

        await admin.messaging().send({
            topic: `user_${bet.uid}`,
            notification: {
                title: "📊 베팅 결과 도착",
                body: won
                    ? `축하합니다! ${bet.amount}P → ${reward}P 획득!`
                    : `아쉽지만 ${bet.amount}P 베팅이 실패했어요. 다음엔 더 좋은 기회가!`,
            },
            data: {
                result: won ? 'win' : 'lose',
                site_id: site_id,
                type_id: type_id,
                amount: bet.amount.toString(),
            },
        });
    }

    await batch.commit();
    console.log(`✅ ${site_id}_${type_id} 베팅 정산 완료 (${isUp ? '상승' : '하락'})`);
}
