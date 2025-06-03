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
        const snapshot = await fetchWaterData(); // ✅ docId + data 반환

        // ② 도전 베팅 생성
        await generateChallengeBets(snapshot);

        // ③ 지난 시각의 베팅 평가
        await resolveBetsUsingSnapshot(snapshot.docId, snapshot.data);

        logger.info(`✅ ${snapshot.docId} 기준 베팅 생성 및 평가 완료`);

    } catch (e) {
        logger.error("📛 scheduledFetchAndResolveBets 실패", e);
    }
});

export const fetchWaterSnapshot = onRequest(async (req, res) => {
    try {
        // ① 수온 데이터 수집 및 저장
        const snapshot = await fetchWaterData(); // ✅ docId + data 반환
        res.status(200).json({
            success: true,
            docId: snapshot.docId,
            count: snapshot.data.length,
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

export const testGenerateChallengeBets = onRequest(async (req, res: any) => {
    try {
        // 가장 최신 스냅샷 가져오기
        const latestSnap = await admin.firestore()
            .collection("water_snapshots")
            .orderBy("createdAt", "desc")
            .limit(1)
            .get();

        if (latestSnap.empty) {
            return res.status(404).json({success: false, message: "📛 water_snapshots 데이터 없음"});
        }

        const doc = latestSnap.docs[0];
        const docId = doc.id;
        const data = doc.data().data;

        // 도전 베팅 생성
        await generateChallengeBets({docId, data});

        return res.status(200).json({
            success: true,
            docId,
            count: data.length,
            message: `✅ 도전 베팅 생성 완료 (${docId})`
        });
    } catch (e: any) {
        console.error("📛 testGenerateChallengeBets 실패", e);
        return res.status(500).json({success: false, message: e.message ?? "알 수 없는 오류"});
    }
});

async function fetchWaterData(): Promise<{ docId: string; data: any[] }> {
    const API_KEY = "53574b6e7069646c3631646b4a4e53";
    const url = `http://openapi.seoul.go.kr:8088/${API_KEY}/json/WPOSInformationTime/1/10`;
    const response = await axios.get(url);

    const rows = response.data?.WPOSInformationTime?.row ?? [];

    // ✅ 한국 시간 기준 Date 객체 생성
    const now = new Date(Date.now() + 9 * 60 * 60 * 1000); // UTC → KST
    now.setMinutes(0, 0, 0); // 분/초/밀리초 제거

    const targetHourStr = now.getHours().toString().padStart(2, "0") + ":00";
    const docId = `${now.getFullYear()}${(now.getMonth() + 1).toString().padStart(2, "0")}${now
        .getDate()
        .toString()
        .padStart(2, "0")}${targetHourStr.slice(0, 2)}00`;

    const filtered = rows.filter((row: { MSR_TIME: string }) => row.MSR_TIME === targetHourStr);
    if (filtered.length === 0) throw new Error(`${targetHourStr} 시각의 데이터 없음`);

    await admin.firestore().collection("water_snapshots").doc(docId).set({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        data: filtered,
    });

    return {docId, data: filtered};
}


async function generateChallengeBets(snapshot: { docId: string; data: any[] }) {
    const betCollection = admin.firestore().collection("bets");
    const betCandidates = [-0.5, -0.3, -0.2, -0.1, +0.1, +0.2, +0.3, +0.5];
    const targetField = "W_TEMP";

    for (const row of snapshot.data) {
        const delta = betCandidates[Math.floor(Math.random() * betCandidates.length)];
        const siteId = row.SITE_ID;
        const baseValue = parseFloat(row[targetField]);

        if (isNaN(baseValue)) {
            logger.warn(`⛔ ${siteId}의 ${targetField} 값이 유효하지 않음`);
            continue;
        }

        const targetValue = parseFloat((baseValue + delta).toFixed(2));
        const deltas = await getLast24hTempChanges(siteId); // 사용자 정의 함수
        const prob = calculateProbability(deltas, delta);

        let odds: number;

        if (prob === 0) {
            logger.warn(`📛 ${siteId}의 ${delta}℃ 조건은 24시간 내 단 1회도 발생하지 않음 → 기본 배당`);
            odds = 3.0;
        } else {
            odds = parseFloat(Math.min(50, 1 / prob).toFixed(1));
        }

        const title = delta > 0
            ? `현재 ${baseValue}℃ → ${targetValue}℃ 이상 상승할까?`
            : `현재 ${baseValue}℃ → ${targetValue}℃ 이하 하락할까?`;

        await betCollection.add({
            siteId,
            snapshotId: snapshot.docId,
            title,
            delta,
            field: targetField,
            baseValue,
            targetValue,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            deadline: new Date(Date.now() + 50 * 60 * 1000), // 50분 후 마감
            odds,
            resolved: false
        });
    }

    logger.info(`✅ 도전 베팅 ${snapshot.data.length}개 생성 완료`);
}

async function getLast24hTempChanges(siteId: string): Promise<number[]> {
    const now = new Date(Date.now() + 9 * 60 * 60 * 1000); // KST
    const past = new Date(now.getTime() - 24 * 60 * 60 * 1000);

    const docs = await admin.firestore()
        .collection("water_snapshots")
        .where("createdAt", ">=", past)
        .orderBy("createdAt", "asc")
        .get();

    const temps: number[] = [];

    for (const doc of docs.docs) {
        const snapshot = doc.data();
        const siteData = snapshot.data.find((d: any) => d.SITE_ID === siteId);
        if (siteData && siteData.W_TEMP) {
            temps.push(parseFloat(siteData.W_TEMP));
        }
    }

    const deltas: number[] = [];
    for (let i = 1; i < temps.length; i++) {
        const delta = temps[i] - temps[i - 1];
        deltas.push(delta);
    }

    return deltas;
}

function calculateProbability(deltas: number[], threshold: number): number {
    const matches = threshold > 0
        ? deltas.filter(d => d >= threshold)
        : deltas.filter(d => d <= threshold);

    const prob = matches.length / (deltas.length || 1); // 0 나눗셈 방지
    return Math.max(prob, 0.01); // 최소 1%
}

async function resolveBetsUsingSnapshot(docId: string, snapshotData: any[]) {
    const betsSnap = await admin.firestore().collection("bets")
        .where("snapshotId", "==", docId)
        .where("resolved", "==", false)
        .get();

    for (const betDoc of betsSnap.docs) {
        const bet = betDoc.data();
        const siteData = snapshotData.find((d: any) => d.SITE_ID === bet.siteId);
        const currentTemp = parseFloat(siteData?.W_TEMP ?? "NaN");

        const passed = bet.delta > 0
            ? currentTemp - bet.baseTemp >= bet.delta
            : currentTemp - bet.baseTemp <= bet.delta;

        await betDoc.ref.update({
            resolved: true,
            result: passed
        });

        const userBetsSnap = await admin.firestore()
            .collectionGroup("user_bets")
            .where("betId", "==", betDoc.id)
            .get();

        for (const ub of userBetsSnap.docs) {
            const data = ub.data();
            const gain = passed ? data.point * data.odds : 0;

            await ub.ref.update({
                isResolved: true,
                isSuccess: passed,
                pointGain: gain,
            });

            if (gain > 0) {
                await admin.firestore().collection("users").doc(data.userId).update({
                    point: admin.firestore.FieldValue.increment(gain)
                });
            }
        }
    }
}
