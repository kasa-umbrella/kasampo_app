import 'dart:io';

abstract class IStorageService {
  Future<String> uploadPhoto(File file, String path);
}
