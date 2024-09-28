import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';
import 'package:journal_web/services/login/login_service.dart';

class LoginRepoImpl implements LoginRepo {
  LoginService loginService;
  LoginRepoImpl(this.loginService);
  @override
  Future<User?> authorSignup(AuthorModel author) async {
    return await loginService.signUp(author, Role.author);
  }

  @override
  Future<User?> editorSignup(EditorModel editor) async {
    return await loginService.signUp(editor, Role.editor);
  }

  @override
  Future<User?> reviewerSignup(ReviewerModel reviewer) async {
    return await loginService.signUp(reviewer, Role.reviewer);
  }

  @override
  Future loginUser(EmailPassModel emailPass) async {
    final user = await loginService.signIn(emailPass.email, emailPass.password);
    return user;
  }

  @override
  Future<void> logOut() async {
    await loginService.logout();
  }
}

class EmailPassModel {
  final String email;
  final String password;

  EmailPassModel({required this.email, required this.password});
}
