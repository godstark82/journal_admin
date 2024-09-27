import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';

abstract class LoginRepo {
  Future<User?> authorSignup(AuthorModel author);

  Future<User?> reviewerSignup(ReviewerModel reviewer);

  Future<User?> editorSignup(EditorModel editor);

  Future loginUser(EmailPassModel emailPass);

  Future<void> logOut();
}
