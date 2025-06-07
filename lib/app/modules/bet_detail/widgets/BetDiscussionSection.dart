import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../data/models/bet_comment.dart';
import '../../../data/utils/logger.dart';

class BetDiscussionSection extends StatefulWidget {
  final String betId;

  const BetDiscussionSection({super.key, required this.betId});

  @override
  State<BetDiscussionSection> createState() => _BetDiscussionSectionState();
}

class _BetDiscussionSectionState extends State<BetDiscussionSection> {
  late final Stream<List<BetComment>> _commentStream;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _commentStream = FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.betId)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => BetComment.fromJson(doc.data()))
        .toList());
  }

  Future<void> _submitComment() async {
    final text = _textController.text.trim();
    final user = FirebaseAuth.instance.currentUser;
    if (text.isEmpty || user == null) return;

    final profile = Get.find<ProfileController>().userProfile.value;
    if (profile == null) return;

    await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.betId)
        .collection('items')
        .add(
      BetComment(
        uid: profile.uid,
        name: profile.name,
        avatarUrl: profile.avatarUrl,
        message: text,
        createdAt: DateTime.now(),
      ).toJson(),
    );

    _textController.clear();
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "💬 토론",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(height: 1),

        /// 댓글 리스트
        Expanded(
          child: StreamBuilder<List<BetComment>>(
            stream: _commentStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                logger.w(snapshot);
                return const Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data!;
              if (comments.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("아무도 내용이 없어요. 첫 번째 토론을 해주세요."),
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: comment.avatarUrl != null
                          ? NetworkImage(comment.avatarUrl!)
                          : null,
                      child: comment.avatarUrl == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text(comment.name ?? "익명"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.message),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('yyyy.MM.dd HH:mm').format(comment.createdAt),
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    dense: true,
                  );
                },
              );
            },
          ),
        ),

        /// 댓글 입력창
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: "댓글을 입력하세요...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _submitComment,
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
