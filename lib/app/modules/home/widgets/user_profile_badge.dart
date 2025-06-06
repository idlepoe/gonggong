import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../../data/controllers/profile_controller.dart';

class UserProfileBadge extends StatelessWidget {
  const UserProfileBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Obx(() {
      final profile = profileController.userProfile.value;

      if (profile == null) {
        return const SizedBox(); // 로딩 중 또는 비로그인
      }

      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const _EditNameModal(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: profile.avatarUrl.isNotEmpty
                    ? NetworkImage(profile.avatarUrl)
                    : null,
                radius: 16,
                child: profile.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on_outlined,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.points}P',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _EditNameModal extends StatefulWidget {
  const _EditNameModal();

  @override
  State<_EditNameModal> createState() => _EditNameModalState();
}

class _EditNameModalState extends State<_EditNameModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final name = Get.find<ProfileController>().userProfile.value?.name ?? '';
    _controller = TextEditingController(text: name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyRandomNickname() async {
    final randomName =
        await Get.find<ProfileController>().generateRandomNickname();
    setState(() {
      _controller.text = randomName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("닉네임 변경",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "새 닉네임을 입력하세요",
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _applyRandomNickname,
                    child: const Text("랜덤 닉네임"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newName = _controller.text.trim();
                      if (newName.isNotEmpty) {
                        await Get.find<ProfileController>().updateName(newName);
                        Navigator.of(context).pop(); // bottom sheet 닫기
                      }
                    },
                    child: const Text("변경하기"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
