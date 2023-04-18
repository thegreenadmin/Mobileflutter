// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';

// class FingerprintAuth extends StatefulWidget {
//   const FingerprintAuth({Key? key}) : super(key: key);

//   @override
//   _FingerprintAuthState createState() => _FingerprintAuthState();
// }

// class _FingerprintAuthState extends State<FingerprintAuth> {
//   final auth = LocalAuthentication();
//   String authorized = " not authorized";
//   bool _canCheckBiometric = false;
//   late List<BiometricType> _availableBiometric;

//   Future<bool> _authenticate() async {
//     bool authenticated = false;
//     try {
//       return await auth.authenticate(
//         // androidAuthStrings: const AndroidAuthMessages(
//         //   signInTitle: 'Face ID Required',
//         // ),
//         localizedReason: 'Scan Face to Authenticate',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//     } on PlatformException catch (e) {
//       return false;
//     }

//     setState(() {
//       authorized =
//           authenticated ? "Authorized success" : "Failed to authenticate";
//       print(authorized);
//     });
//   }

//   Future<void> _checkBiometric() async {
//     bool canCheckBiometric = false;

//     try {
//       canCheckBiometric = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       print(e);
//     }

//     if (!mounted) return;

//     setState(() {
//       _canCheckBiometric = canCheckBiometric;
//     });
//   }

//   Future _getAvailableBiometric() async {
//     List<BiometricType> availableBiometric = [];

//     try {
//       availableBiometric = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       print(e);
//     }

//     setState(() {
//       _availableBiometric = availableBiometric;
//     });
//   }

//   @override
//   void initState() {
//     _checkBiometric();
//     _getAvailableBiometric();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey.shade600,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Center(
//               child: Text(
//                 "Login",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 48.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 50.0),
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.symmetric(vertical: 15.0),
//                     child: const Text(
//                       "Authenticate using your fingerprint instead of your password",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white, height: 1.5),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(vertical: 15.0),
//                     width: double.infinity,
//                     child: FloatingActionButton(
//                       onPressed: _authenticate,
//                       elevation: 0.0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 24.0, vertical: 14.0),
//                         child: Text(
//                           "Authenticate",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thegreenmall/utils/app_colors.dart';
import 'package:thegreenmall/utils/constants.dart';
import 'package:thegreenmall/utils/image_constants.dart';
import 'package:thegreenmall/utils/sizedbox_constants.dart';

class FingerPrintScreen extends StatefulWidget {
  const FingerPrintScreen({super.key});

  @override
  State<FingerPrintScreen> createState() => _FingerPrintScreenState();
}

class _FingerPrintScreenState extends State<FingerPrintScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: AppColors.primarylight,
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.black,
                                  size: 24.0,
                                ),
                              ),
                              width10SizedBox,
                              Text(
                                StringConstants.authenticationText,
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Image.asset(
                            ImageConstants.homeMall,
                            scale: 4,
                          )
                        ]),
                  ],
                )),
          )),
      body: ListView(
        padding: const EdgeInsets.only(top: 30),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_supportState == _SupportState.unknown)
                const CircularProgressIndicator()
              else if (_supportState == _SupportState.supported)
                const Center(
                  child: Text(
                    'This device is supported for biometric authenication.',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 28,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400),
                  ),
                )
              else
                const Center(
                  child: Text(
                    'This device is not supported for biometric authenication.',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 28,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              const Divider(height: 100),
              // Text('Can check biometrics: $_canCheckBiometrics\n'),
              // ElevatedButton(
              //   onPressed: _checkBiometrics,
              //   child: const Text('Check biometrics'),
              // ),
              // const Divider(height: 100),
              // Text('Available biometrics: $_availableBiometrics\n'),
              // ElevatedButton(
              //   onPressed: _getAvailableBiometrics,
              //   child: const Text('Get available biometrics'),
              // ),
              // const Divider(height: 100),
              Text('Current State: You are $_authorized\n'),
              if (_isAuthenticating)
                ElevatedButton(
                  onPressed: _cancelAuthentication,
                  // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
                  // ignore: prefer_const_constructors
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('Cancel Authentication'),
                      Icon(Icons.cancel),
                    ],
                  ),
                )
              else
                Column(
                  children: <Widget>[
                    // ElevatedButton(
                    //   onPressed: _authenticate,
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: const <Widget>[
                    //       Text('Authenticate'),
                    //       Icon(Icons.perm_device_information),
                    //     ],
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: _authenticateWithBiometrics,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_isAuthenticating
                              ? 'Cancel'
                              : 'Authenticate: biometrics only'),
                          const Icon(Icons.fingerprint),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
