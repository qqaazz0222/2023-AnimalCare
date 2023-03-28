import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Server{
  static const String serverUrl = "http://127.0.0.1:3001";
}

class SecureStorage{
  final storage = const FlutterSecureStorage();

  final String _keyUserName = 'username';

  Future setUserName(String username) async {
    await storage.write(key: _keyUserName, value: username);
  }

  Future<String?> getUserName() async {
    return await storage.read(key: _keyUserName);
  }
}