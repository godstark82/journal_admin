import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    

    if (LoginConst.currentUser?.id == null) {
      return RouteSettings(name: '/login'); // Redirect to login page
    }
    return null; // Allow access if logged in
  }
}