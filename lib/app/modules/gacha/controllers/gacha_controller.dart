import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/artwork_model.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';

class GachaController extends GetxController {
  final artworks = <Artwork>[].obs;
  final ownedIds = <String>{}.obs;

  final isLoading = false.obs;

  static const _cacheKey = 'cached_artworks';
  static const _cacheTimeKey = 'artworks_last_updated';

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await Future.wait([
      loadArtworksFromLocalOrServer(),
      fetchOwnedIds(),
    ]);
  }

  final showUnowned = false.obs;

  List<Artwork> get filteredArtworks {
    if (showUnowned.value) return artworks;
    return artworks.where((a) => isOwned(a.id)).toList();
  }

  Future<void> loadArtworksFromLocalOrServer() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final lastUpdatedStr = prefs.getString(_cacheTimeKey);
      final lastUpdated =
          lastUpdatedStr != null ? DateTime.tryParse(lastUpdatedStr) : null;

      // ✅ 7일 이내 캐시가 있다면 로컬 데이터 사용
      if (lastUpdated != null &&
          now.difference(lastUpdated) < const Duration(days: 7)) {
        final cachedJson = prefs.getString(_cacheKey);
        if (cachedJson != null) {
          final List decoded = json.decode(cachedJson);
          artworks.assignAll(decoded.map((e) => Artwork.fromJson(e)).toList());
          return;
        }
      }

      // ✅ 서버에서 전체 로딩
      final snapshot =
          await FirebaseFirestore.instance.collection('artworks').get();

      final newList = snapshot.docs.map((doc) {
        final data = doc.data();
        return Artwork.fromJson({...data, 'id': doc.id});
      }).toList();

      artworks.assignAll(newList);

      // ✅ SharedPreferences에 저장
      await prefs.setString(
          _cacheKey, json.encode(newList.map((e) => e.toJson()).toList()));
      await prefs.setString(_cacheTimeKey, now.toIso8601String());
    } catch (e) {
      print('🔥 Error loading artworks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 현재 유저의 소유 작품 ID 불러오기
  Future<void> fetchOwnedIds() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('artworks') // ✅ 서브컬렉션 경로
          .get();

      final ids = snapshot.docs.map((doc) => doc.id).toList();
      ownedIds.addAll(ids);

      logger.i("✅ 소장 작품 ID: $ownedIds");
    } catch (e) {
      print("🔥 Error fetching owned artwork IDs: $e");
    }
  }

  bool isOwned(String id) => ownedIds.contains(id);

  Future<void> drawGacha() async {
    isLoading.value = true;
    try {
      final newArtwork = await ApiService().purchaseRandomArtwork();
      if (newArtwork != null) {
        logger.w(newArtwork);
        ownedIds.add(newArtwork["artworkId"]);
        Get.snackbar('🎁 가챠 결과', '${newArtwork["artwork"]["prdct_nm_korean"]} 획득!');
      }
    } catch (e) {
      logger.e(e);
      Get.snackbar('실패', '가챠 중 오류 발생');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchaseRandomArtwork() async {
    isLoading.value = true;
    try {
      final result = await ApiService().purchaseRandomArtwork();
      if (result != null && result['artworkId'] != null) {
        final newArtwork = Artwork.fromJson(result['artwork']);
        ownedIds.add(newArtwork.id);
        Get.snackbar('🎁 가챠 결과', '${newArtwork.nameKr} 획득!');
      }
    } catch (e) {
      Get.snackbar('실패', '가챠 중 오류 발생');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchaseArtwork(Artwork artwork) async {
    isLoading.value = true;
    try {
      final result = await ApiService().purchaseArtwork(artwork.id);
      if (result != null && result['success'] == true) {
        ownedIds.add(artwork.id);
        Get.snackbar('🎉 구매 완료', '${artwork.nameKr}를 소장했습니다!');
      }
    } catch (e) {
      Get.snackbar('실패', '작품 구매 중 오류 발생');
    } finally {
      isLoading.value = false;
    }
  }
}
