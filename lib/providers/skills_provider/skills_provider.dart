import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/providers/file_upload_provider/file_upload_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'skills_provider.g.dart';

@riverpod
class SkillList extends _$SkillList {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _skills =>
      _firestore.collection('skills');

  @override
  Future<List<Skill>> build() async {
    final snapshot = await _skills.get();
    if (snapshot.docs.isNotEmpty) {
      final list =
          snapshot.docs
              .map((doc) => Skill.fromJson(doc.data(), id: doc.id))
              .toList()
            ..sort((a, b) => a.order.compareTo(b.order));

      return list;
    } else {
      throw Exception('No skills found');
    }
  }

  Future<void> addSkill({required Skill skill, Uint8List? imageBytes}) async {
    String? logoUrl;

    if (imageBytes != null) {
      logoUrl = await ref.read(
        uploadImageProvider(
          bytes: imageBytes,
          folder: 'skills',
          fileName: skill.name,
        ).future,
      );
    }

    final docRef = await _skills.add(skill.copyWith(avatar: logoUrl).toJson());

    await docRef.get().then((value) async {
      await Future.delayed(const Duration(seconds: 1), () async {
        final skill = Skill.fromJson(value.data()!, id: value.id);
        final skills = await future;
        skills
          ..add(skill)
          ..sort((a, b) => a.order.compareTo(b.order));
        state = AsyncValue.data(skills);
      });
    });
  }

  Future<void> deleteSkill(Skill skill) async {
    if (skill.avatar != null) {
      await ref.read(deleteFileFromUrlProvider(url: skill.avatar!).future);
    }
    await _skills.doc(skill.id).delete();

    final skills = await future;
    skills
      ..removeWhere((s) => s.id == skill.id)
      ..sort((a, b) => a.order.compareTo(b.order));
    state = AsyncValue.data(skills);
  }

  Future<void> updateSkill({
    required String id,
    required Skill skill,
    Uint8List? imageBytes,
  }) async {
    var logoUrl = skill.avatar;

    if (imageBytes != null) {
      if (logoUrl != null) {
        await ref.read(deleteFileFromUrlProvider(url: logoUrl).future);
      }

      logoUrl = await ref.read(
        uploadImageProvider(
          bytes: imageBytes,
          folder: 'companies',
          fileName: skill.name,
        ).future,
      );
    } else {}

    await _skills.doc(id).update(skill.copyWith(avatar: logoUrl).toJson());

    ref.invalidateSelf();
    await future;
  }

  Future<void> reorder({required int oldIndex, required int newIndex}) async {
    if (oldIndex < newIndex) {
      newIndex--;
    }

    final skills = await future;
    final skill = skills.removeAt(oldIndex);
    skills.insert(newIndex, skill);
    state = AsyncValue.data(skills);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final idToken = await user.getIdToken();

    try {
      await http.post(
        Uri.parse(
          'https://us-central1-portfolio-site-34489.cloudfunctions.net/updateSkillOrder',
        ),
        headers: {'Authorization': 'Bearer $idToken'},
        body: {'skillId': skill.id, 'newOrder': newIndex.toString()},
      );
    } on Exception {
      //
    }
  }
}
