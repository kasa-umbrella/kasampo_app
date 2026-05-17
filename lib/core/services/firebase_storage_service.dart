import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'i_storage_service.dart';

class FirebaseStorageService implements IStorageService {
  final _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadPhoto(File file, String path) async {
    final compressed = await _compress(file);
    final ref = _storage.ref(path);
    await ref.putFile(compressed);
    return ref.getDownloadURL();
  }

  @override
  Future<void> deletePhoto(String downloadUrl) async {
    await _storage.refFromURL(downloadUrl).delete();
  }

  Future<File> _compress(File file) async {
    final ext = file.path.contains('.') ? '.${file.path.split('.').last}' : '.jpg';
    final outPath = '${file.path}_compressed$ext';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      minWidth: 1200,
      minHeight: 1200,
      quality: 85,
    );
    return result != null ? File(result.path) : file;
  }
}
