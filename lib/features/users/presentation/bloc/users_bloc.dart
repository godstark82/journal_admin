import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';
import 'package:journal_web/features/users/domain/usecases/get_all_users_usecase.dart';
import 'package:journal_web/features/users/domain/usecases/get_specific_user_usecase.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetSpecificUserUsecase getSpecificUserUseCase;
  UsersBloc(
    this.getAllUsersUseCase,
    this.getSpecificUserUseCase,
  ) : super(UsersInitial()) {
    on<GetUsersEvent>(_onGetUsersEvent);
    on<GetSpecificUserEvent>(_onGetSpecificUserEvent);
  }

  Future<void> _onGetUsersEvent(
      GetUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    final users = await getAllUsersUseCase.call({});
    emit(UsersLoaded(users: users.data));
  }

  Future<void> _onGetSpecificUserEvent(
      GetSpecificUserEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    final user = await getSpecificUserUseCase.call(event.userId);
    emit(UsersLoadedSpecific(user: user.data));
  }
}
