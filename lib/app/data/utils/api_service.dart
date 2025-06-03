import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
}
