import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';
import 'package:journal_web/features/users/domain/repositories/users_repo.dart';

class GetAllUsersUseCase extends UseCase<DataState<List<MyUser>>, void> {
  final UsersRepo _usersRepo;

  GetAllUsersUseCase(this._usersRepo);

  @override
  Future<DataState<List<MyUser>>> call(void params) async {
    return await _usersRepo.getAllUsers();
  }
}
