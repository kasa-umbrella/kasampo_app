abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthException extends AppException {
  const AuthException([super.message = '認証エラーが発生しました']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'ネットワークエラーが発生しました']);
}

class StorageException extends AppException {
  const StorageException([super.message = 'ストレージエラーが発生しました']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'データが見つかりませんでした']);
}

class PermissionException extends AppException {
  const PermissionException([super.message = '権限が必要です']);
}