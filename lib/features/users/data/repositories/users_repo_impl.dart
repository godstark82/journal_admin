import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';
import 'package:journal_web/features/users/domain/repositories/users_repo.dart';
import 'package:journal_web/services/users_service.dart';

class UsersRepoImpl implements UsersRepo {
  final UsersService _usersService;

  UsersRepoImpl(this._usersService);

  @override
  Future<DataState<List<MyUser>>> getAllUsers() async {
    return await _usersService.getAllUsers();
  }

  @override
  Future<DataState<MyUser?>> getUserInfo(String userId) async {
    return await _usersService.getUserInfo(userId);
  }
}
