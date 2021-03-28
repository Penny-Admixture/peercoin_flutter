import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peercoin/models/coinwallet.dart';

class EncryptedBox with ChangeNotifier {
  Map<String, Box> _cryptoBox = {};
  Uint8List _encryptionKey;
  String _passCode;
  FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Uint8List> get key async {
    if (_encryptionKey == null) {
      var containsEncryptionKey = await _secureStorage.containsKey(key: 'key');
      if (!containsEncryptionKey) {
        var key = Hive.generateSecureKey();
        await _secureStorage.write(key: 'key', value: base64UrlEncode(key));
      }
      _encryptionKey = base64Url.decode(await _secureStorage.read(key: 'key'));
    }
    return _encryptionKey;
  }

  Future<String> get passCode async {
    if (_passCode == null) {
      _passCode = await _secureStorage.read(key: "passCode");
    }
    return _passCode;
  }

  Future<bool> setPassCode(String passCode) async {
    await _secureStorage.write(key: "passCode", value: passCode);
    _passCode = passCode;
    return true;
  }

  Future<Box> getGenericBox(String name) async {
    _cryptoBox[name] = await Hive.openBox(
      name,
      encryptionCipher: HiveAesCipher(await key),
    );
    return _cryptoBox[name];
  }

  Future<Box> getWalletBox() async {
    return await Hive.openBox<CoinWallet>(
      "wallets",
      encryptionCipher: HiveAesCipher(await key),
    );
  }
}
