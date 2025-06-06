import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../data/models/artwork_model.dart';
import '../controllers/gacha_controller.dart';

void showArtworkBottomSheet(
    BuildContext context, Artwork artwork, bool isOwned, int userPoints) {
  final controller = Get.find<GachaController>();
  final price = artwork.price;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 닫기 버튼 (상단 정렬)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (isOwned) ...[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: artwork.mainImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("🎨 ${artwork.nameKr}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("👤 작가: ${artwork.writer}"),
                  Text("📆 제작년도: ${artwork.manufactureYear}"),
                  Text("🖌️ 재료: ${artwork.material}"),
                  Text("📏 크기: ${artwork.standard}"),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          final encodedTitle = Uri.encodeComponent(artwork.nameKr);
                          final encodedWriter = Uri.encodeComponent(artwork.writer);
                          final url =
                              'https://sema.seoul.go.kr/kr/knowledge_research/collection/list?currentPage=1&kwdValue=$encodedTitle&wriName=$encodedWriter&artKname=$encodedTitle';
                          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text("작품 정보 더 보기"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final profileController = Get.find<ProfileController>();
                          profileController.updateAvatarUrl(artwork.mainImage);
                          Get.snackbar('🙌 완료', '프로필 사진이 변경되었습니다!');
                        },
                        icon: const Icon(Icons.account_circle, size: 20),
                        label: const Text("내 아바타로"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[100],
                          foregroundColor: Colors.deepPurple[900],
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  )
                ] else ...[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: artwork.mainImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: Colors.grey.withOpacity(0.6),
                        colorBlendMode: BlendMode.saturation,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("💰 소장 가격: $price pt",
                      style: const TextStyle(fontSize: 16)),
                  Text("🙋‍♂️ 내 보유 포인트: $userPoints pt"),
                  if (userPoints < price)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '포인트가 부족해요 😢',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (userPoints >= price)
                    ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await controller.purchaseArtwork(artwork);
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("소장하기"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}
