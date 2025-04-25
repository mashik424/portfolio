import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/providers/file_upload_provider/file_upload_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'projects_provider.g.dart';

@riverpod
class ProjectsList extends _$ProjectsList {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  @override
  Future<List<Project>> build() async {
    final snapshot =
        await _firestore
            .collection('projects')
            .orderBy('date_of_creation', descending: true)
            .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs
          .map((doc) => Project.fromJson(doc.data(), id: doc.id))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> addProject({
    required Project project,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    if (imageBytes != null) {
      imageUrl = await ref.read(
        uploadImageProvider(
          bytes: imageBytes,
          folder: 'projects',
          fileName: project.name,
        ).future,
      );
    }

    await _firestore
        .collection('projects')
        .add(
          project.copyWith(imageUrl: imageUrl).toJson()
            ..addAll({'date_of_creation': DateTime.now()}),
        );

    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteProject({required Project project}) async {
    if (project.imageUrl != null) {
      await ref.read(deleteFileFromUrlProvider(url: project.imageUrl!).future);
    }

    await _firestore.collection('projects').doc(project.id).delete();

    ref.invalidateSelf();
    await future;
  }

  Future<void> updateProject({
    required String id,
    required Project project,
    Uint8List? bytes,
  }) async {
    var imageUrl = project.imageUrl;

    if (bytes != null) {
      if (imageUrl != null) {
        await ref.read(deleteFileFromUrlProvider(url: imageUrl).future);
      }

      imageUrl = await ref.read(
        uploadImageProvider(
          bytes: bytes,
          folder: 'projects',
          fileName: project.name,
        ).future,
      );
    }

    await _firestore
        .collection('projects')
        .doc(id)
        .update(project.copyWith(imageUrl: imageUrl).toJson());

    ref.invalidateSelf();
    await future;
  }
}
