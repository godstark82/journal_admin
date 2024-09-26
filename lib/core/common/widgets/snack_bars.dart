import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySnacks {
  static Future<void> showErrorSnack(String content) async {
    Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: content,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3)));
  }
}
