import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';

class AuthorSignupUsecase extends UseCase<User?, AuthorModel> {
  LoginRepo repo;
  AuthorSignupUsecase(this.repo);
  @override
  Future<User?> call(AuthorModel params) async {
    return await repo.authorSignup(params);
  }
}
