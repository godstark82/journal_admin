import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';

class EditorSignupUsecase extends UseCase<User?, EditorModel> {
  LoginRepo repo;
  EditorSignupUsecase(this.repo);
  @override
  Future<User?> call(EditorModel params) async {
    return await repo.editorSignup(params);
  }
}
