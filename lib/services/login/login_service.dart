import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/core/common/widgets/snack_bars.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/login/data/models/admin_model.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class LoginService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //! Sign up with email and password
  Future<User?> signUp(MyUser myuser, String role) async {
    try {
      //! Create new User in firebase
      final UserCredential credentials =
          await auth.createUserWithEmailAndPassword(
              email: myuser.email!, password: myuser.password!);

      //! Create new document in users collection for userdata
      final User? user = credentials.user;
      if (user != null) {
        myuser.role = role;
        myuser.id = user.uid;
        await firestore
            .collection('users')
            .doc(user.uid)
            .set({'createdAt': DateTime.now(), ...myuser.toJson()});
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

  //! Sign in with email and password
  Future<dynamic> signIn(String email, String password) async {
    try {
      //! Sign in the user with email and password
      final UserCredential credentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);

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
            log(role);
            //! Return appropriate model based on the role
            switch (role) {
              case Role.author:
                return AuthorModel.fromJson(userData);
              case Role.reviewer:
                return ReviewerModel.fromJson(userData);
              case Role.editor:
                return EditorModel.fromJson(userData);
              case Role.admin:
                return AdminModel.fromJson(userData);
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        MySnacks.showErrorSnack('No user found for that email.');
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        MySnacks.showErrorSnack('Wrong password provided.');
        log('Wrong password provided.');
      } else {
        MySnacks.showErrorSnack(e.message ?? 'Authentication error.');
        log(e.code);
      }
    } catch (e) {
      MySnacks.showErrorSnack('An error occurred: ${e.toString()}');
      log(e.toString());
    }

    return null;
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      //
      log(e.toString());
    }
  }
}
