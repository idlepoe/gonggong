import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../data/models/artwork_model.dart';
import '../../../data/utils/api_service.dart';
import '../../../data/utils/logger.dart';

class GachaController extends GetxController {
  final artworks = <Artwork>[].obs;
  final ownedIds = <String>{}.obs;


  final isLoading = false.obs;
  final hasMore = true.obs;

  DocumentSnapshot? lastDoc;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  static const int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchArtworks();
  }

  Future<void> fetchInitialData() async {
    await Future.wait([
      fetchArtworks(reset: true),
      fetchOwnedIds(),
    ]);
  }

  /// Firestore에서 아트워크 페이징 로드
  Future<void> fetchArtworks({bool reset = false}) async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    try {
      Query query = _firestore
          .collection('artworks')
          .orderBy('mnfct_year', descending: true)
          .limit(pageSize);

      if (!reset && lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }

      final snapshot = await query.get();
      final docs = snapshot.docs;

      if (reset) {
        artworks.clear();
        lastDoc = null;
        hasMore.value = true;
      }

      if (docs.isNotEmpty) {
        final newArtworks = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Artwork.fromJson({...data, 'id': doc.id});
        }).toList();

        artworks.addAll(newArtworks);
        lastDoc = docs.last;

        if (docs.length < pageSize) {
          hasMore.value = false;
        }
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      print("🔥 Error fetching artworks: $e");
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
          .collection('user_owned_artworks')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final ids = List<String>.from(data['owned'] ?? []);
        ownedIds.addAll(ids);
      }
    } catch (e) {
      print("🔥 Error fetching owned artwork IDs: $e");
    }
  }

  bool isOwned(String id) => ownedIds.contains(id);

  void fetchMoreArtworks() => fetchArtworks();

  Future<void> drawGacha() async {
    isLoading.value = true;
    try {
      final newArtwork = await ApiService().purchaseRandomArtwork();
      if (newArtwork != null) {
        ownedIds.add(newArtwork.id);
        Get.snackbar('🎁 가챠 결과', '${newArtwork.prdctNmKorean} 획득!');
      }
    } catch (e) {
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
