import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class LoginConst {
  static MyUser? currentUser;

  static void updateLoginConsts({
    MyUser? user,
  }) async {
    currentUser = user ?? currentUser;
    await Hive.box('cache').put('currentUser', currentUser?.toJson());
  }

  static void clearLoginConsts() async {
    currentUser = null;
    await Hive.box('cache').clear();
  }

  static void printLoginConsts() {
    log('currentRole: ${currentUser?.role}');
    log('currentUserName: ${currentUser?.name}');
    log('currentUserId: ${currentUser?.id}');
    log('currentUserEmail: ${currentUser?.email}');
    log('currentUser: ${currentUser?.journalIds}');
  }

  static Future<void> getCurrentUser() async {
    final hiveBox = Hive.box('cache');
    final userJson = await hiveBox.get('currentUser');
    currentUser = userJson != null ? MyUser.fromJson(userJson) : null;
    printLoginConsts();
  }
}
