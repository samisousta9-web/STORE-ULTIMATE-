import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;
  bool _isInitialized = false;

  void initialize(String masterKey) {
    final keyBytes = sha256.convert(utf8.encode(masterKey)).bytes;
    final key = encrypt.Key(Uint8List.fromList(keyBytes));
    // استخدم IV ثابت مشتق من المفتاح أو احفظه مع البيانات
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    _isInitialized = true;
  }

  String encryptText(String plainText) {
    if (!_isInitialized) throw StateError('EncryptionService not initialized');
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    // احفظ IV مع النص المشفر (Base64)
    return '${_iv.base64}:${encrypted.base64}';
  }

  String decryptText(String encryptedText) {
    if (!_isInitialized) throw StateError('EncryptionService not initialized');
    final parts = encryptedText.split(':');
    if (parts.length != 2) throw FormatError('Invalid encrypted format');
    final iv = encrypt.IV.fromBase64(parts[0]);
    return _encrypter.decrypt64(parts[1], iv: iv);
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }
}
