import 'package:get_it/get_it.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';
import 'package:journal_web/features/login/domain/usecases/author_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/editor_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/login_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/logout_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/reviewer_signup_usecase.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/services/author_services.dart';
import 'package:journal_web/services/editor_service.dart';
import 'package:journal_web/services/login_service.dart';
import 'package:journal_web/services/reviewer_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //! Services
  sl.registerSingleton<AuthorServices>(AuthorServices());
  sl.registerSingleton<LoginService>(LoginService());
  sl.registerSingleton<EditorServices>(EditorServices());
  sl.registerSingleton<ReviewerService>(ReviewerService());

  //! Repositories
  sl.registerSingleton<LoginRepo>(LoginRepoImpl(sl(), sl(), sl(), sl()));

  //! Usecases
  sl.registerSingleton<AuthorSignupUsecase>(AuthorSignupUsecase(sl()));
  sl.registerSingleton<EditorSignupUsecase>(EditorSignupUsecase(sl()));
  sl.registerSingleton<ReviewerSignupUsecase>(ReviewerSignupUsecase(sl()));
  sl.registerSingleton<LoginUsecase>(LoginUsecase(sl()));
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase(sl()));

  //! Blocs
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl(), sl(), sl(), sl(), sl()));
}
