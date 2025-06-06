import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../data/models/artwork_model.dart';
import '../../../data/utils/logger.dart';
import '../controllers/gacha_controller.dart';

class GachaView extends GetView<GachaController> {
  const GachaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎨 서울시립미술관")),
      body: Obx(() {
        if (controller.artworks.isEmpty && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels >=
                    scrollNotification.metrics.maxScrollExtent - 200 &&
                controller.hasMore.value) {
              controller.fetchMoreArtworks();
            }
            return false;
          },
          child: MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: controller.artworks.length,
            itemBuilder: (context, index) {
              final artwork = controller.artworks[index];
              final isOwned = controller.isOwned(artwork.id);

              return InkWell(
                onTap: () {
                  if (isOwned) return; // 이미 소장한 경우는 무시

                  final profileController = Get.find<ProfileController>();
                  final userPoints =
                      profileController.userProfile.value?.points ?? 0;
                  final price = artwork.price;

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('🎁 작품 소장하기'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🎨 ${artwork.nameKr}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('👤 ${artwork.writer}'),
                          const SizedBox(height: 12),
                          Text('💰 소장 가격: $price pt'),
                          Text('🙋‍♂️ 현재 보유: $userPoints pt'),
                          if (userPoints < price)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                '포인트가 부족해요 😢',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            '닫기',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        if (userPoints >= price)
                          ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await controller.purchaseArtwork(artwork);
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: const Text(
                              '소장하기',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue),
                          ),
                      ],
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: artwork.thumbImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                color: isOwned
                                    ? null
                                    : Colors.grey.withOpacity(0.6),
                                colorBlendMode:
                                    isOwned ? null : BlendMode.saturation,
                              ),
                            ),
                            if (!isOwned)
                              const Positioned.fill(
                                child: Center(
                                  child: Icon(Icons.lock_outline,
                                      size: 40, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("🎨 ${artwork.nameKr}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text("👤 ${artwork.writer}"),
                        Text("📆 ${artwork.manufactureYear}"),
                        Text("🖌️ ${artwork.material}"),
                        Text("📏 ${artwork.standard}")
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            onPressed: controller.isLoading.value ? null : controller.drawGacha,
            backgroundColor: Colors.lightBlue,
            label: const Text(
              "서울시립 미술관 작품 뽑기",
              style: TextStyle(color: Colors.white),
            ),
            icon: controller.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Icon(Icons.brush, color: Colors.white),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void launchArtworkSearch(Artwork artwork) {
    final encodedTitle = Uri.encodeComponent(artwork.nameKr);
    final encodedWriter = Uri.encodeComponent(artwork.writer);

    final url =
        'https://sema.seoul.go.kr/kr/knowledge_research/collection/list?currentPage=1&kwdValue=$encodedTitle&wriName=$encodedWriter&artKname=$encodedTitle';

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
