import 'package:hive/hive.dart';
part "app_options.g.dart";

@HiveType(typeId: 5)
class AppOptionsStore extends HiveObject {
  @HiveField(0)
  Map<String, bool> _authenticationOptions = {
    "walletList": false,
    "walletHome": false,
    "sendTransaction": true,
    "newWallet": false,
  };

  @HiveField(1)
  bool _allowBiometrics = true;

  @HiveField(2)
  String _defaultWallet = "";

  AppOptionsStore(this._allowBiometrics);

  bool get allowBiometrics {
    return _allowBiometrics;
  }

  set allowBiometrics(bool newStatus) {
    _allowBiometrics = newStatus;
    this.save();
  }

  Map<String, bool> get authenticationOptions {
    return _authenticationOptions;
  }

  void changeAuthenticationOptions(String field, bool value) {
    _authenticationOptions[field] = value;
    this.save();
  }

  get defaultWallet {
    return _defaultWallet;
  }

  set defaultWallet(String newWallet) {
    _defaultWallet = newWallet;
    this.save();
  }
}
