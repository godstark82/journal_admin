import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';

class LoginUsecase extends UseCase<dynamic, EmailPassModel> {
  final LoginRepo loginRepo;
  LoginUsecase(this.loginRepo);

  @override
  Future call(EmailPassModel params) async {
    return (await loginRepo.loginUser(params));
  }
}
