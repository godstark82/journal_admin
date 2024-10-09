import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/login/data/models/admin_model.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

class UsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DataState<List<MyUser>>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('users').get();
      return DataSuccess(querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MyUser.fromJson(data);
      }).toList());
    } catch (e) {
      print('Error fetching users: $e');
      return DataFailed(e.toString());
    }
  }

  Future<DataState<MyUser?>> getUserInfo(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData.containsKey('role')) {
          final String role = userData['role'];
          switch (role) {
            case Role.author:
              return DataSuccess(AuthorModel.fromJson(userData));
            case Role.reviewer:
              return DataSuccess(ReviewerModel.fromJson(userData));
            case Role.editor:
              return DataSuccess(EditorModel.fromJson(userData));
            case Role.admin:
              return DataSuccess(AdminModel.fromJson(userData));
            default:
              print('Invalid role: $role');
              return DataFailed('Invalid role');
          }
        } else {
          print('No role found for this user.');
          return DataFailed('User not found');
        }
      } else {
        print('User does not exist.');
        return DataFailed('User not found');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return DataFailed(e.toString());
    }
  }

  Future<void> updateUserJournals(String userId, List<String> journalIds) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'journalIds': journalIds,
      });
    } catch (e) {
      print('Error updating user journals: $e');
    }
  }
}
