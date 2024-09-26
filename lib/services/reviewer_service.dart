import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/services/login_service.dart';

class ReviewerService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  //
  Future<User?> signUp(ReviewerModel reviewer) async {
    try {
      //! Create new User in firebase
      final UserCredential credentials =
          await auth.createUserWithEmailAndPassword(
              email: reviewer.email!, password: reviewer.password!);

      //! Create new document in users collection for userdata
      final User? user = credentials.user;
      if (user != null) {
        reviewer.role = Role.reviewer;
        await firestore
            .collection('users')
            .doc(user.uid)
            .set({'createdAt': DateTime.now(), ...reviewer.toJson()});
      }

      // return the user
      return credentials.user;

      //Handeling exceptions
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        MySnacks.showErrorSnack('The password provided is too weak.');

        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        MySnacks.showErrorSnack('Email Already Exists...');

        log('The account already exists for that email.');
      } else {
        MySnacks.showErrorSnack(e.code);
        log(e.code);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<ReviewerModel?> signIn(String email, String password) async {
    try {
      //! Sign in the user with email and password
      LoginService loginService = LoginService();
      return (await loginService.signIn(email, password) as ReviewerModel);
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}
