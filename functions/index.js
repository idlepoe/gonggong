const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const {getFirestore} = require("firebase-admin/firestore");
const {initializeApp} = require("firebase-admin/app");
const moment = require("moment");
const {FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {setGlobalOptions} = require("firebase-functions/v2");
const axios = require("axios");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {onObjectFinalized} = require("firebase-functions/v2/storage");

initializeApp();
setGlobalOptions({region: 'asia-northeast3'});

async function getData() {
    const today = moment().format('YYYYMMDD');
    const yesterday = moment().subtract(1, 'day').format('YYYYMMDD');

    const eqkList = await readEvents();
    logger.debug(eqkList);
    for (let i = 0; i < eqkList.length; i++) {
        // 어제 데이터만
        if (
            eqkList[i]["ORIGIN_TIME"] >= (yesterday + "000000")
            &&
            eqkList[i]["ORIGIN_TIME"] <= today + "000000"
        ) {
            await getFirestore()
                .collection("01eqk")
                .add(eqkList[i]);
        }
    }
    logger.debug("event write end");
}

async function readEvents(_currentPage, _perPageRow) {
    try {
        const response = await axios.get('http://openapi.seoul.go.kr:8088/6478766f6569646c3635647643707a/json/TbEqkKenvinfo/1/10/');
        return response.data['TbEqkKenvinfo']["row"];
    } catch (e) {
        logger.error(e);
    }
}

exports.scheduledRefreshData = onSchedule("0 9 * * *", async (event) => {
    await getData();
});

exports.callSchedule = onRequest({cors: true}, async (request, response) => {
    logger.info("callSchedule");
    logger.log(request.body);
    try {
        await getData();
        response.status(200).json({result: "callSchedule"});
    } catch (e) {
        logger.error(e);
        response.status(500).json({result: e.result});
    }
});

exports.addUser = onRequest({cors: true}, async (request, response) => {
    logger.info("addUser");
    logger.log(request.body);
    try {
        const writeResult = await getFirestore()
            .collection("users")
            .add({
                ...request.body,
                point: 0,
                updated_at: moment.now(),
            });
        response.status(200).json({result: `users ${writeResult.id} added.`});
    } catch (e) {
        logger.error(e);
        response.status(500).json({result: e.result});
    }
});

exports.writeComment = onRequest({cors: true}, async (request, response) => {
    logger.info("writeComment");
    logger.log(request.body);
    try {
        const writeResult = await getFirestore()
            .collection("comments")
            .add({
                ...request.body,
                updated_at: moment.now(),
            });
        response.status(200).json({result: `comments ${writeResult.id} added.`});
    } catch (e) {
        logger.error(e);
        response.status(500).json({result: e.result});
    }
});
