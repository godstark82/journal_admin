import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';

abstract class UsersRepo {
  Future<DataState<List<MyUser>>> getAllUsers();
  Future<DataState<MyUser?>> getUserInfo(String userId);
}
