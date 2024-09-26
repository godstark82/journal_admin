import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/features/home/presentation/pages/home.dart';
import 'package:journal_web/features/login/data/models/author_model.dart';
import 'package:journal_web/features/login/data/models/editor_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';
import 'package:journal_web/features/login/domain/usecases/author_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/editor_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/login_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/reviewer_signup_usecase.dart';
import 'package:journal_web/features/login/presentation/pages/login_page.dart';
import 'package:journal_web/routes.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthorSignupUsecase authorSignupUsecase;
  final EditorSignupUsecase editorSignupUsecase;
  final ReviewerSignupUsecase reviewerSignupUsecase;
  final LoginUsecase loginUsecase;
  LoginBloc(this.authorSignupUsecase, this.editorSignupUsecase,
      this.reviewerSignupUsecase, this.loginUsecase)
      : super(LoginInitial()) {
    //
    on<LoginAuthorSignupEvent>(onAuthorSignup);
    on<LoginEditorSignupEvent>(onEditorSignup);
    on<LoginReviewerSignupEvent>(onReviewerSignup);
    on<LoginInitiateLoginEvent>(onLogin);
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
      emit(LoginDoneState());
      if (user is AuthorModel) {
        AuthorModel author = user;
        LoginConst.currentRole = author.role!;
      } else if (user is EditorModel) {
        EditorModel editor = user;
        LoginConst.currentRole = editor.role!;
      } else if (user is ReviewerModel) {
        ReviewerModel reviewer = user;
        LoginConst.currentRole = reviewer.role!;
      } else {
        LoginConst.currentRole = 'ADMIN';
      }
      Get.offAllNamed(Routes.dashboard);
    } else {
      emit(LoginInitial());
    }
    // } catch (e) {
    // emit(LoginInitial());
    // log(e.toString());
    // }
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
        emit(LoginDoneState());
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
        emit(LoginDoneState());
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
        emit(LoginDoneState());
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
