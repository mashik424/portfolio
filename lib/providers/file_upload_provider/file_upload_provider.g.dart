// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$uploadFileHash() => r'a808a4c12b0fcbfdeebc9ef4dbd31cdf544e2733';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [uploadFile].
@ProviderFor(uploadFile)
const uploadFileProvider = UploadFileFamily();

/// See also [uploadFile].
class UploadFileFamily extends Family<AsyncValue<String>> {
  /// See also [uploadFile].
  const UploadFileFamily();

  /// See also [uploadFile].
  UploadFileProvider call({
    required Uint8List bytes,
    required String filePath,
  }) {
    return UploadFileProvider(bytes: bytes, filePath: filePath);
  }

  @override
  UploadFileProvider getProviderOverride(
    covariant UploadFileProvider provider,
  ) {
    return call(bytes: provider.bytes, filePath: provider.filePath);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'uploadFileProvider';
}

/// See also [uploadFile].
class UploadFileProvider extends AutoDisposeFutureProvider<String> {
  /// See also [uploadFile].
  UploadFileProvider({required Uint8List bytes, required String filePath})
    : this._internal(
        (ref) =>
            uploadFile(ref as UploadFileRef, bytes: bytes, filePath: filePath),
        from: uploadFileProvider,
        name: r'uploadFileProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$uploadFileHash,
        dependencies: UploadFileFamily._dependencies,
        allTransitiveDependencies: UploadFileFamily._allTransitiveDependencies,
        bytes: bytes,
        filePath: filePath,
      );

  UploadFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bytes,
    required this.filePath,
  }) : super.internal();

  final Uint8List bytes;
  final String filePath;

  @override
  Override overrideWith(
    FutureOr<String> Function(UploadFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UploadFileProvider._internal(
        (ref) => create(ref as UploadFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bytes: bytes,
        filePath: filePath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _UploadFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UploadFileProvider &&
        other.bytes == bytes &&
        other.filePath == filePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bytes.hashCode);
    hash = _SystemHash.combine(hash, filePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UploadFileRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `bytes` of this provider.
  Uint8List get bytes;

  /// The parameter `filePath` of this provider.
  String get filePath;
}

class _UploadFileProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with UploadFileRef {
  _UploadFileProviderElement(super.provider);

  @override
  Uint8List get bytes => (origin as UploadFileProvider).bytes;
  @override
  String get filePath => (origin as UploadFileProvider).filePath;
}

String _$getFileUrlHash() => r'76d4fdbc678bd8e7068b2862ac89108bdcd13553';

/// See also [getFileUrl].
@ProviderFor(getFileUrl)
const getFileUrlProvider = GetFileUrlFamily();

/// See also [getFileUrl].
class GetFileUrlFamily extends Family<AsyncValue<String>> {
  /// See also [getFileUrl].
  const GetFileUrlFamily();

  /// See also [getFileUrl].
  GetFileUrlProvider call({required String path}) {
    return GetFileUrlProvider(path: path);
  }

  @override
  GetFileUrlProvider getProviderOverride(
    covariant GetFileUrlProvider provider,
  ) {
    return call(path: provider.path);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getFileUrlProvider';
}

/// See also [getFileUrl].
class GetFileUrlProvider extends AutoDisposeFutureProvider<String> {
  /// See also [getFileUrl].
  GetFileUrlProvider({required String path})
    : this._internal(
        (ref) => getFileUrl(ref as GetFileUrlRef, path: path),
        from: getFileUrlProvider,
        name: r'getFileUrlProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$getFileUrlHash,
        dependencies: GetFileUrlFamily._dependencies,
        allTransitiveDependencies: GetFileUrlFamily._allTransitiveDependencies,
        path: path,
      );

  GetFileUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    FutureOr<String> Function(GetFileUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFileUrlProvider._internal(
        (ref) => create(ref as GetFileUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GetFileUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFileUrlProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFileUrlRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `path` of this provider.
  String get path;
}

class _GetFileUrlProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with GetFileUrlRef {
  _GetFileUrlProviderElement(super.provider);

  @override
  String get path => (origin as GetFileUrlProvider).path;
}

String _$getFileFromUrlHash() => r'da43040a0d462efea28e15d6865b8ef53be73889';

/// See also [getFileFromUrl].
@ProviderFor(getFileFromUrl)
const getFileFromUrlProvider = GetFileFromUrlFamily();

/// See also [getFileFromUrl].
class GetFileFromUrlFamily extends Family<AsyncValue<Uint8List>> {
  /// See also [getFileFromUrl].
  const GetFileFromUrlFamily();

  /// See also [getFileFromUrl].
  GetFileFromUrlProvider call({required String url}) {
    return GetFileFromUrlProvider(url: url);
  }

  @override
  GetFileFromUrlProvider getProviderOverride(
    covariant GetFileFromUrlProvider provider,
  ) {
    return call(url: provider.url);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getFileFromUrlProvider';
}

/// See also [getFileFromUrl].
class GetFileFromUrlProvider extends AutoDisposeFutureProvider<Uint8List> {
  /// See also [getFileFromUrl].
  GetFileFromUrlProvider({required String url})
    : this._internal(
        (ref) => getFileFromUrl(ref as GetFileFromUrlRef, url: url),
        from: getFileFromUrlProvider,
        name: r'getFileFromUrlProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$getFileFromUrlHash,
        dependencies: GetFileFromUrlFamily._dependencies,
        allTransitiveDependencies:
            GetFileFromUrlFamily._allTransitiveDependencies,
        url: url,
      );

  GetFileFromUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<Uint8List> Function(GetFileFromUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFileFromUrlProvider._internal(
        (ref) => create(ref as GetFileFromUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Uint8List> createElement() {
    return _GetFileFromUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFileFromUrlProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFileFromUrlRef on AutoDisposeFutureProviderRef<Uint8List> {
  /// The parameter `url` of this provider.
  String get url;
}

class _GetFileFromUrlProviderElement
    extends AutoDisposeFutureProviderElement<Uint8List>
    with GetFileFromUrlRef {
  _GetFileFromUrlProviderElement(super.provider);

  @override
  String get url => (origin as GetFileFromUrlProvider).url;
}

String _$deleteFileFromUrlHash() => r'7fca3cd66a5804ff3109cf8d67d1ee6fdfb15466';

/// See also [deleteFileFromUrl].
@ProviderFor(deleteFileFromUrl)
const deleteFileFromUrlProvider = DeleteFileFromUrlFamily();

/// See also [deleteFileFromUrl].
class DeleteFileFromUrlFamily extends Family<AsyncValue<void>> {
  /// See also [deleteFileFromUrl].
  const DeleteFileFromUrlFamily();

  /// See also [deleteFileFromUrl].
  DeleteFileFromUrlProvider call({required String url}) {
    return DeleteFileFromUrlProvider(url: url);
  }

  @override
  DeleteFileFromUrlProvider getProviderOverride(
    covariant DeleteFileFromUrlProvider provider,
  ) {
    return call(url: provider.url);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteFileFromUrlProvider';
}

/// See also [deleteFileFromUrl].
class DeleteFileFromUrlProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteFileFromUrl].
  DeleteFileFromUrlProvider({required String url})
    : this._internal(
        (ref) => deleteFileFromUrl(ref as DeleteFileFromUrlRef, url: url),
        from: deleteFileFromUrlProvider,
        name: r'deleteFileFromUrlProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$deleteFileFromUrlHash,
        dependencies: DeleteFileFromUrlFamily._dependencies,
        allTransitiveDependencies:
            DeleteFileFromUrlFamily._allTransitiveDependencies,
        url: url,
      );

  DeleteFileFromUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteFileFromUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteFileFromUrlProvider._internal(
        (ref) => create(ref as DeleteFileFromUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteFileFromUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteFileFromUrlProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeleteFileFromUrlRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `url` of this provider.
  String get url;
}

class _DeleteFileFromUrlProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with DeleteFileFromUrlRef {
  _DeleteFileFromUrlProviderElement(super.provider);

  @override
  String get url => (origin as DeleteFileFromUrlProvider).url;
}

String _$uploadImageHash() => r'dce5322fb733a8237a195d60f65bd5d358b9f8e9';

/// See also [uploadImage].
@ProviderFor(uploadImage)
const uploadImageProvider = UploadImageFamily();

/// See also [uploadImage].
class UploadImageFamily extends Family<AsyncValue<String>> {
  /// See also [uploadImage].
  const UploadImageFamily();

  /// See also [uploadImage].
  UploadImageProvider call({
    required Uint8List bytes,
    required String folder,
    required String fileName,
  }) {
    return UploadImageProvider(
      bytes: bytes,
      folder: folder,
      fileName: fileName,
    );
  }

  @override
  UploadImageProvider getProviderOverride(
    covariant UploadImageProvider provider,
  ) {
    return call(
      bytes: provider.bytes,
      folder: provider.folder,
      fileName: provider.fileName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'uploadImageProvider';
}

/// See also [uploadImage].
class UploadImageProvider extends AutoDisposeFutureProvider<String> {
  /// See also [uploadImage].
  UploadImageProvider({
    required Uint8List bytes,
    required String folder,
    required String fileName,
  }) : this._internal(
         (ref) => uploadImage(
           ref as UploadImageRef,
           bytes: bytes,
           folder: folder,
           fileName: fileName,
         ),
         from: uploadImageProvider,
         name: r'uploadImageProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$uploadImageHash,
         dependencies: UploadImageFamily._dependencies,
         allTransitiveDependencies:
             UploadImageFamily._allTransitiveDependencies,
         bytes: bytes,
         folder: folder,
         fileName: fileName,
       );

  UploadImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bytes,
    required this.folder,
    required this.fileName,
  }) : super.internal();

  final Uint8List bytes;
  final String folder;
  final String fileName;

  @override
  Override overrideWith(
    FutureOr<String> Function(UploadImageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UploadImageProvider._internal(
        (ref) => create(ref as UploadImageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bytes: bytes,
        folder: folder,
        fileName: fileName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _UploadImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UploadImageProvider &&
        other.bytes == bytes &&
        other.folder == folder &&
        other.fileName == fileName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bytes.hashCode);
    hash = _SystemHash.combine(hash, folder.hashCode);
    hash = _SystemHash.combine(hash, fileName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UploadImageRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `bytes` of this provider.
  Uint8List get bytes;

  /// The parameter `folder` of this provider.
  String get folder;

  /// The parameter `fileName` of this provider.
  String get fileName;
}

class _UploadImageProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with UploadImageRef {
  _UploadImageProviderElement(super.provider);

  @override
  Uint8List get bytes => (origin as UploadImageProvider).bytes;
  @override
  String get folder => (origin as UploadImageProvider).folder;
  @override
  String get fileName => (origin as UploadImageProvider).fileName;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
