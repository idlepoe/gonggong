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

async function fetchWaterData(): Promise<{ docId: string; data: any[] }> {
    const API_KEY = "53574b6e7069646c3631646b4a4e53";
    const url = `http://openapi.seoul.go.kr:8088/${API_KEY}/json/WPOSInformationTime/1/10`;
    const response = await axios.get(url);

    const rows = response.data?.WPOSInformationTime?.row ?? [];

    // ✅ 한국 시간 기준 Date 객체 생성
    const now = new Date(Date.now() + 9 * 60 * 60 * 1000); // UTC → KST
    now.setMinutes(0, 0, 0); // 분/초/밀리초 제거

    const targetHourStr = now.getHours().toString().padStart(2, "0") + ":00";
    const docId =
        `${now.getFullYear()}` +
        `${(now.getMonth() + 1).toString().padStart(2, "0")}` +
        `${now.getDate().toString().padStart(2, "0")}` +
        `${targetHourStr.slice(0, 2)}00`;

    const filtered = rows.filter((row: { MSR_TIME: string }) => row.MSR_TIME === targetHourStr);
    if (filtered.length === 0) throw new Error(`${targetHourStr} 시각의 데이터 없음`);

    // ✅ SITE_ID → 슬러그 변환 테이블
    const siteSlugMap: Record<string, string> = {
        "탄천": "tancheon",
        "중랑천": "jungnang",
        "안양천": "anyang",
        "한강": "hangang",
        // 필요 시 추가
    };

    // ✅ 각 data에 challengeId 포함
    const enrichedData = filtered.map((row: any) => {
        const siteId = row.SITE_ID;
        const slug = siteSlugMap[siteId] ?? siteId.replace(/\s+/g, "_").toLowerCase(); // fallback

        return {
            ...row,
            challengeId: `${docId}_${slug}`,
        };
    });

    // ✅ Firestore 저장
    await admin.firestore().collection("water_snapshots").doc(docId).set({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        data: enrichedData,
    });

    return {docId, data: enrichedData};
}

