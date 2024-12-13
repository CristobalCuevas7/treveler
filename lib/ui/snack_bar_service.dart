import 'package:flutter/material.dart';

class SnackBarService {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey => _scaffoldMessengerKey;

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ));
    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}

final SnackBarService snackBarService = SnackBarService();
