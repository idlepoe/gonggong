import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/api_constants.dart';
import '../models/bet.dart';
import 'dio.dart';
import 'logger.dart';

class ApiService {
  static Future<String> uploadFileToStorage({required XFile xFile}) async {
    logger.d(xFile.toString());

    String result = "";
    try {
      Reference reference = FirebaseStorage.instance.ref().child(
            "uploads/${DateTime.now().millisecondsSinceEpoch.toString()}_${xFile.name}",
          );
      await reference.putData(await xFile.readAsBytes());
      result = await reference.getDownloadURL();
      logger.d(result);
    } catch (e) {
      logger.e(e);
      logger.e(e.toString());
      return e.toString();
    }

    return result;
  }

  Future<void> placeBetWithModel(Bet bet) async {
    try {
      final res = await dio.post(ApiConstants.placeBet, data: bet.toJson());
      logger.i("✅ placeBet 성공: ${res.data}");
    } catch (e) {
      logger.e("❌ placeBet 실패: $e");
      rethrow;
    }
  }

  Future<dynamic> cancelBet(String uid, String siteId, String typeId) async {
    try {
      final res = await dio.post(
        ApiConstants.placeBet,
        data: {
          "uid": uid,
          "site_id": siteId,
          "type_id": typeId,
          "cancel": true, // ❗️cancel 플래그 사용
        },
      );
      return res.data;
    } catch (e) {
      logger.e("❌ cancelBet error: $e");
      rethrow;
    }
  }

  Future<dynamic> purchaseRandomArtwork() async {
    try {
      final res = await dio.post(
        ApiConstants.purchaseRandomArtwork,
      );
      return res.data;
    } catch (e) {
      logger.e("❌ purchaseRandomArtwork error: $e");
      rethrow;
    }
  }

  Future<dynamic> purchaseArtwork(artworkId) async {
    try {
      final res = await dio.post(
        ApiConstants.purchaseArtwork,
        data: {
          "artworkId": artworkId, // String
        },
      );

      return res.data;
    } catch (e) {
      logger.e("❌ purchaseArtwork error: $e");
      rethrow;
    }
  }
}
