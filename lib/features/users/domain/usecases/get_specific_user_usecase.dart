import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';
import 'package:journal_web/features/users/domain/repositories/users_repo.dart';

class GetSpecificUserUsecase extends UseCase<DataState<MyUser?>, String> {
  final UsersRepo _usersRepo;

  GetSpecificUserUsecase(this._usersRepo);

  @override
  Future<DataState<MyUser?>> call(String params) async {
    return await _usersRepo.getUserInfo(params);
  }
}
