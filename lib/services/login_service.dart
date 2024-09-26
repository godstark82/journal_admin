import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';

class LoginService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<dynamic> signIn(String email, String password) async {
    // try {
    //! Sign in the user with email and password
    final UserCredential credentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    //! Get the current user
    final User? user = credentials.user;

    if (user != null) {
      //! Fetch user data from Firestore
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        //! Extract user data from Firestore
        final userData = userDoc.data();
        if (userData != null && userData.containsKey('role')) {
          final String role = userData['role'];

          //! Return appropriate model based on the role
          switch (role) {
            case Role.author:
              return AuthorModel.fromJson(userData);
            case Role.reviewer:
              return ReviewerModel.fromJson(userData);
            case Role.editor:
              return EditorModel.fromJson(userData);
            default:
              MySnacks.showErrorSnack('Invalid role.');
              log('Invalid role: $role');
              return null;
          }
        } else {
          MySnacks.showErrorSnack('No role found for this user.');
          log('No role found for this user.');
        }
      } else {
        MySnacks.showErrorSnack('User does not exist.');
      }
    }
    // } on FirebaseAuthException catch (e) {
    // if (e.code == 'user-not-found') {
    // MySnacks.showErrorSnack('No user found for that email.');
    // log('No user found for that email.');
    // } else if (e.code == 'wrong-password') {
    // MySnacks.showErrorSnack('Wrong password provided.');
    // log('Wrong password provided.');
    // } else {
    // MySnacks.showErrorSnack(e.message ?? 'Authentication error.');
    // log(e.code);
    // }
    // } catch (e) {
    // MySnacks.showErrorSnack('An error occurred: ${e.toString()}');
    // log(e.toString());
    // }

    return null;
  }
}
