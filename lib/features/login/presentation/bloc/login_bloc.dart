import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';
import 'package:journal_web/features/login/domain/entities/my_user_entity.dart';
import 'package:journal_web/features/login/domain/usecases/author_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/editor_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/login_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/logout_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/reviewer_signup_usecase.dart';
import 'package:journal_web/routes.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthorSignupUsecase authorSignupUsecase;
  final EditorSignupUsecase editorSignupUsecase;
  final ReviewerSignupUsecase reviewerSignupUsecase;
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  LoginBloc(this.authorSignupUsecase, this.editorSignupUsecase,
      this.reviewerSignupUsecase, this.loginUsecase, this.logoutUsecase)
      : super(LoginInitial()) {
    //
    on<LoginAuthorSignupEvent>(onAuthorSignup);
    on<LoginEditorSignupEvent>(onEditorSignup);
    on<LoginReviewerSignupEvent>(onReviewerSignup);
    on<LoginInitiateLoginEvent>(onLogin);
    on<LogoutEvent>(onLogout);
  }

  void onLogout(LogoutEvent event, Emitter<LoginState> emit) async {
    try {
      await logoutUsecase.call({}).whenComplete(() {
        Get.offAllNamed(Routes.login);
        LoginConst.clearLoginConsts();
      });

      emit(LoginInitial());
    } catch (e) {
      log(e.toString());
    }
  }

  void onLogin(LoginInitiateLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    // try {
    final user = await loginUsecase.call(event.emailPass).onError((e, st) {
      log(e.toString());
      emit(LoginInitial());
      return null;
    });
    if (user != null) {
      emit(LoginDoneState(role: user.role!));
      LoginConst.updateLoginConsts(
          user: MyUser(
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        journalIds: user.journalIds,
        designation: user.designation,
      ));
      LoginConst.printLoginConsts();
      Get.offAllNamed(Routes.dashboard);
    } else {
      emit(LoginInitial());
    }
  }

  void onAuthorSignup(
      LoginAuthorSignupEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final user =
          await authorSignupUsecase.call(event.author).onError((e, st) {
        emit(LoginInitial());
        return null;
      });
      if (user != null) {
        emit(LoginDoneState(role: Role.author));
        Get.offAllNamed(Routes.login);
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      emit(LoginInitial());
      log(e.toString());
    }
  }

  //! Editor
  void onEditorSignup(
      LoginEditorSignupEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final user =
          await editorSignupUsecase.call(event.editor).onError((e, st) {
        emit(LoginInitial());
        return null;
      });
      if (user != null) {
        emit(LoginDoneState(role: Role.editor));
        Get.offAllNamed(Routes.login);
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      emit(LoginInitial());
      log(e.toString());
    }
  }

  //! Reviewer

  void onReviewerSignup(
      LoginReviewerSignupEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final user =
          await reviewerSignupUsecase.call(event.reviewer).onError((e, st) {
        emit(LoginInitial());
        return null;
      });
      if (user != null) {
        emit(LoginDoneState(role: Role.reviewer));
        Get.offAllNamed(Routes.login);
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      emit(LoginInitial());
      log(e.toString());
    }
  }
}
