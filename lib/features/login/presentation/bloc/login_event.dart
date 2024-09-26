part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginAuthorSignupEvent extends LoginEvent {
  final AuthorModel author;

  const LoginAuthorSignupEvent({required this.author});
}

class LoginEditorSignupEvent extends LoginEvent {
  final EditorModel editor;

  const LoginEditorSignupEvent({required this.editor});
}

class LoginReviewerSignupEvent extends LoginEvent {
  final ReviewerModel reviewer;

  const LoginReviewerSignupEvent({required this.reviewer});
}

class LoginInitiateLoginEvent extends LoginEvent {
  final EmailPassModel emailPass;

  const LoginInitiateLoginEvent(this.emailPass);
}
