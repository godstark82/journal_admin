import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';
import 'package:journal_web/features/users/domain/usecases/get_all_users_usecase.dart';
import 'package:journal_web/features/users/domain/usecases/get_specific_user_usecase.dart';
import 'package:journal_web/features/users/domain/usecases/update_user_journals_uc.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetSpecificUserUsecase getSpecificUserUseCase;
  final UpdateUserJournalsUC updateUserJournalsUC;
  UsersBloc(
    this.getAllUsersUseCase,
    this.getSpecificUserUseCase,
    this.updateUserJournalsUC,
  ) : super(UsersInitial()) {
    on<GetUsersEvent>(_onGetUsersEvent);
    on<GetSpecificUserEvent>(_onGetSpecificUserEvent);
    on<UpdateUserJournalsEvent>(_onUpdateUserJournalsEvent);
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

  Future<void> _onUpdateUserJournalsEvent(
      UpdateUserJournalsEvent event, Emitter<UsersState> emit) async {
    await updateUserJournalsUC.call(event.userId, event.journalIds);
    add(GetSpecificUserEvent(userId: event.userId));
  }
}
