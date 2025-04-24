import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/models/skill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'skills_provider.g.dart';

@riverpod
class SkillList extends _$SkillList {
  @override
  Future<List<Skill>> build() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('skills').get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs
          .map((doc) => Skill.fromJson(doc.data(), id: doc.id))
          .toList();
    } else {
      throw Exception('No skills found');
    }
  }

  Future<void> addSkill(Skill skill) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('skills').add(skill.toJson());

    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteSkill(String id) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('skills').doc(id).delete();

    ref.invalidateSelf();
    await future;
  }
}
