import 'package:get/get_state_manager/get_state_manager.dart';

import '../main.dart';
import '../utils/http.dart';

class ApiController extends GetxController {
  Future<String> addUser({
    required String id,
    required String name,
  }) async {
    var apiResult = await dio.post("/addUser", data: {
      "id": id,
      "name": name,
    });
    logger.d(apiResult);
    return apiResult.data["result"];
  }
}
