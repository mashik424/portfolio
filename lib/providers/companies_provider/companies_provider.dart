import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio/models/company.dart';
import 'package:portfolio/providers/file_upload_provider/file_upload_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'companies_provider.g.dart';

@riverpod
class CompaniesList extends _$CompaniesList {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _companies =>
      _firestore.collection('companies');

  @override
  Future<List<Company>> build() async {
    final snapshot = await _companies.get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs
          .map((doc) => Company.fromJson(doc.data(), id: doc.id))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> addCompany({
    required Company company,
    Uint8List? imageBytes,
  }) async {
    String? logoUrl;

    if (imageBytes != null) {
      logoUrl = await ref.read(
        uploadImageProvider(
          bytes: imageBytes,
          folder: 'companies',
          fileName: company.name,
        ).future,
      );
    }

    await _companies.add(company.copyWith(logoUrl: logoUrl).toJson());

    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteCompany({required Company company}) async {
    if (company.logoUrl != null) {
      await ref.read(deleteFileFromUrlProvider(url: company.logoUrl!).future);
    }
    await _companies.doc(company.id).delete();

    ref.invalidateSelf();
    await future;
  }

  Future<void> updateCompany({
    required String id,
    required Company company,
    Uint8List? imageBytes,
  }) async {
    var logoUrl = company.logoUrl;

    if (imageBytes != null) {
      if (logoUrl != null) {
        await ref.read(deleteFileFromUrlProvider(url: logoUrl).future);
      }

      logoUrl = await ref.read(
        uploadImageProvider(
          bytes: imageBytes,
          folder: 'companies',
          fileName: company.name,
        ).future,
      );
    }

    await _companies
        .doc(id)
        .update(company.copyWith(logoUrl: logoUrl).toJson());

    ref.invalidateSelf();
    await future;
  }
}
