import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggong/app/modules/gacha/widgets/show_artwork_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../data/models/artwork_model.dart';
import '../controllers/gacha_controller.dart';

class ArtworkCard extends StatelessWidget {
  final Artwork artwork;
  final bool isOwned;

  const ArtworkCard({super.key, required this.artwork, required this.isOwned});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final userPoints = profileController.userProfile.value?.points ?? 0;

    return InkWell(
      onTap: () =>
          showArtworkBottomSheet(context, artwork, isOwned, userPoints),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      color: isOwned ? null : Colors.grey.withOpacity(0.6),
                      colorBlendMode: isOwned ? null : BlendMode.saturation,
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
              Text(
                "🎨 ${artwork.nameKr}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOwned ? Colors.black : Colors.grey,
                ),
              ),
              if (isOwned) ...[
                Text("👤 ${artwork.writer}"),
                Text("📆 ${artwork.manufactureYear}"),
                Text("🖌️ ${artwork.material}"),
                Text("📏 ${artwork.standard}"),
              ]
            ],
          ),
        ),
      ),
    );
  }


}
