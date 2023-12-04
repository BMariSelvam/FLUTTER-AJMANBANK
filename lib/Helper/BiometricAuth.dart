import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// /This class defines the utility class for biometric authentication in our app/
class BiometricAuth {

  BiometricAuth._privateConstructor();

  static final BiometricAuth getInstance = BiometricAuth._privateConstructor();

  bool isDialogShowing = false;

  factory BiometricAuth() => getInstance;

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _auth.canCheckBiometrics;
final bool canAuthenticate = canCheckBiometrics || await _auth.isDeviceSupported(); //this will check device is support
    } catch (e) {
      canCheckBiometrics = false;
    }
    return canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = <BiometricType>[];

    if (await _auth.canCheckBiometrics) {
      try {
        availableBiometrics = await _auth.getAvailableBiometrics();
      } catch (e, s) {
        // LoggerUtil.getInstance.print(s.toString());
      }
    } else {
      // LoggerUtil.getInstance.print("Cannot check biometrics");
    }

    return availableBiometrics;
  }

  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
            useErrorDialogs: false
        ),);
    } catch (e) {
      return false;
    }
    return authenticated;
  }

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      // LoggerUtil.getInstance.print(e);
      return false;
    }
    return authenticated;
  }


  Future<void> cancelAuthentication() async {
    await _auth.stopAuthentication();
  }
}