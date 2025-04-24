import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_upload_provider.g.dart';

@riverpod
Future<String> uploadFile(
  Ref ref, {
  required Uint8List bytes,
  required String filePath,
}) async {
  final storage = FirebaseStorage.instance;
  final storageRef = storage.ref().child(filePath);
  final uploadTask = await storageRef.putData(bytes);

  final url = await uploadTask.ref.getDownloadURL();

  return url;
}

@riverpod
Future<String> getFileUrl(Ref ref, {required String path}) async {
  final ref = FirebaseStorage.instance.ref().child(path);
  return ref.getDownloadURL();
}

@riverpod
Future<Uint8List> getFileFromUrl(Ref ref, {required String url}) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load file from URL');
  }
}

@riverpod
Future<void> deleteFileFromUrl(Ref ref, {required String url}) async {
  final storage = FirebaseStorage.instance;
  try {
    final ref = storage.refFromURL(url);
    await ref.delete();
  } on Exception {
    //
  }
}

@riverpod
Future<String> uploadImage(
  Ref ref, {
  required Uint8List bytes,
  required String folder,
  required String fileName,
}) async {
  final mimeType = lookupMimeType('', headerBytes: bytes);
  if (mimeType == null || !mimeType.startsWith('image/')) {
    throw Exception('Invalid file type. Only image files are allowed.');
  }

  final fileExtension = mimeType.split('/').last;
  if (fileExtension.isEmpty) {
    throw Exception('Unable to determine file extension.');
  }

  final imageUrl = await ref.read(
    uploadFileProvider(
      bytes: bytes,
      filePath: '$folder/$fileName.$fileExtension',
    ).future,
  );

  return imageUrl;
}
