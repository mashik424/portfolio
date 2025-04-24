import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web/web.dart' as web;

part 'pick_image_provider.g.dart';

@riverpod
Future<Uint8List?> pickImage(Ref ref) async {
  final completer = Completer<Uint8List?>();
  final input =
      web.document.createElement('input') as web.HTMLInputElement
        ..type = 'file'
        ..accept = 'image/*'
        ..click();

  input.onChange.listen((event) {
    final file = input.files?.item(0);
    if (file != null) {
      final reader = web.FileReader();

      reader.onLoadEnd.listen((event) async {
        final result = reader.result;

        if (result != null) {
          //
          // ignore: invalid_runtime_check_with_js_interop_types
          final arrayBuffer = result as ByteBuffer;
          final bytes = Uint8List.view(arrayBuffer);
          completer.complete(bytes);
          return;
        }

        completer.complete(null);
      });

      reader.readAsArrayBuffer(file);
    }
  });

  return completer.future;
}
