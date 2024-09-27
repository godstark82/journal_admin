import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';
import 'package:journal_web/services/author_services.dart';
import 'package:journal_web/services/editor_service.dart';
import 'package:journal_web/services/login_service.dart';
import 'package:journal_web/services/reviewer_service.dart';

class LoginRepoImpl implements LoginRepo {
  AuthorServices authorServices;
  LoginService loginService;
  EditorServices editorServices;
  ReviewerService reviewerService;

  LoginRepoImpl(this.authorServices, this.editorServices, this.reviewerService,
      this.loginService);
  @override
  Future<User?> authorSignup(AuthorModel author) async {
    return await authorServices.signUp(author);
  }

  @override
  Future<User?> editorSignup(EditorModel editor) async {
    return await editorServices.signUp(editor);
  }

  @override
  Future<User?> reviewerSignup(ReviewerModel reviewer) async {
    return await reviewerService.signUp(reviewer);
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
