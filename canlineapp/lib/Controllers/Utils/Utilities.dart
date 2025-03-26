import 'dart:io';

import 'package:flutter/material.dart';

class Utilities extends ChangeNotifier {
  // Refresh the screen
  Future<void> Refresh() async {
    notifyListeners();
    debugPrint('Refreshed');
  }

  // Check Internet Connection using dart:io
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
}
