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
}
