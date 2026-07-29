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

  void initialize(String masterKey) {
    final key = encrypt.Key.fromUtf8(masterKey.padRight(32, '0').substring(0, 32));
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }

  String encryptText(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  String decryptText(String encryptedText) {
    return _encrypter.decrypt64(encryptedText, iv: _iv);
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }
}
