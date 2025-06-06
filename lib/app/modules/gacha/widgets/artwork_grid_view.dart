import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../controllers/gacha_controller.dart';
import 'artwork_card.dart';

class ArtworkGridView extends StatelessWidget {
  ArtworkGridView({super.key});

  final GachaController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchInitialData,
      child: Obx(
        () => MasonryGridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          crossAxisCount: 2,
          itemCount: controller.filteredArtworks.length,
          itemBuilder: (context, index) {
            final artwork = controller.filteredArtworks[index];
            final isOwned = controller.isOwned(artwork.id);
            return ArtworkCard(artwork: artwork, isOwned: isOwned);
          },
        ),
      ),
    );
  }
}
