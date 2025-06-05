import axios from "axios";
import * as admin from "firebase-admin";

export async function fetchWaterData(): Promise<void> {
    const API_KEY = "53574b6e7069646c3631646b4a4e53";
    const url = `http://openapi.seoul.go.kr:8088/${API_KEY}/json/WPOSInformationTime/1/10`;

    const response = await axios.get(url);
    const rows = response.data?.WPOSInformationTime?.row ?? [];

    // 현재 시간 (KST)
    const now = new Date(Date.now() + 9 * 60 * 60 * 1000);
    now.setMinutes(0, 0, 0);

    const targetHourStr = now.getHours().toString().padStart(2, "0") + ":00";

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

        const endDate = new Date(startDate.getTime() + 60 * 60 * 1000);

        const parentDocId = `${site_id}_${type_id}`;
        const valueDocId = `${row.MSR_DATE}${row.MSR_TIME.replace(":", "")}`;

        const question = `한 시간 뒤 ${name}의 수온은 오를까?`;

        const parentRef = db.collection("measurements").doc(parentDocId);
        const valueRef = parentRef.collection("values").doc(valueDocId);

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
    console.log(`✅ ${filtered.length}개의 수온 데이터 저장 완료 (서브컬렉션 구조 적용됨)`);
}

export async function placeBetting({
                                   uid,
                                   site_id,
                                   type_id,
                                   amount,
                                   up,
                               }: {
    uid: string;
    site_id: string;
    type_id: string;
    amount: number;
    up: boolean;
}): Promise<void> {
    const db = admin.firestore();
    const userRef = db.collection('users').doc(uid);
    const betRef = db
        .collection('bets')
        .doc(`${site_id}_${type_id}`)
        .collection('entries')
        .doc(uid);

    await db.runTransaction(async (tx) => {
        const userSnap = await tx.get(userRef);

        if (!userSnap.exists) {
            throw new Error("User not found");
        }

        const userData = userSnap.data();
        const currentPoints = userData?.points ?? 0;

        if (currentPoints < amount) {
            throw new Error("Insufficient points");
        }

        tx.update(userRef, {
            points: currentPoints - amount,
        });

        tx.set(betRef, {
            uid,
            site_id,
            type_id,
            amount,
            up, // true: 상승에 베팅, false: 하락에 베팅
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    });

    console.log(`✅ ${uid} 베팅 완료 (${site_id}_${type_id}, ${up ? '상승' : '하락'}, ${amount}포인트)`);
}

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

        const won = (bet.up === isUp);
        if (won) {
            const reward = bet.amount * 2; // 승리 보상은 예시로 2배
            batch.update(userRef, {
                points: admin.firestore.FieldValue.increment(reward),
            });
        }

        // 베팅 내역 제거 or 기록 보존
        batch.delete(doc.ref); // 또는 기록용 `bets_history`로 옮길 수 있음
    }

    await batch.commit();
    console.log(`✅ ${site_id}_${type_id} 베팅 정산 완료 (${isUp ? '상승' : '하락'})`);
}
