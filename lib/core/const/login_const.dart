import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

class LoginConst {
  static String? currentRole;
  static String? currentUserName;
  static String? currentUserId;
  static String? currentUserEmail;

  static void updateLoginConsts({
    String? role,
    String? userName,
    String? userId,
    String? userEmail,
  }) async {
    currentRole = role ?? currentRole;
    currentUserName = userName ?? currentUserName;
    currentUserId = userId ?? currentUserId;
    currentUserEmail = userEmail ?? currentUserEmail;

    await Hive.box('cache').put('currentRole', currentRole);
    await Hive.box('cache').put('currentUserName', currentUserName);
    await Hive.box('cache').put('currentUserId', currentUserId);
    await Hive.box('cache').put('currentUserEmail', currentUserEmail);
  }

  static void clearLoginConsts() async {
    currentRole = '';
    currentUserName = '';
    currentUserId = '';
    currentUserEmail = '';
    await Hive.box('cache').clear();
  }

  static void printLoginConsts() {
    log('currentRole: $currentRole');
    log('currentUserName: $currentUserName');
    log('currentUserId: $currentUserId');
    log('currentUserEmail: $currentUserEmail');
  }

  static Future<void> getCurrentUser() async {
    final hiveBox = Hive.box('cache');
    currentRole = hiveBox.get('currentRole');
    currentUserName = hiveBox.get('currentUserName');
    currentUserId = hiveBox.get('currentUserId');
    currentUserEmail = hiveBox.get('currentUserEmail');
    printLoginConsts();
  }
}
