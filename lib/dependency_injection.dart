import 'package:get_it/get_it.dart';
import 'package:journal_web/features/article/data/repositories/article_repo_impl.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';
import 'package:journal_web/features/article/domain/usecases/add_article_usecase.dart';
import 'package:journal_web/features/article/domain/usecases/delete_article_usecase.dart';
import 'package:journal_web/features/article/domain/usecases/get_articles_usecase.dart';
import 'package:journal_web/features/article/domain/usecases/update_article_usecase.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';
import 'package:journal_web/features/login/domain/usecases/author_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/editor_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/login_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/logout_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/reviewer_signup_usecase.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/services/article/article_service.dart';
import 'package:journal_web/services/login/login_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //! Services
  sl.registerSingleton<LoginService>(LoginService());
  sl.registerSingleton<ArticleService>(ArticleService());

  //! Repositories
  sl.registerSingleton<LoginRepo>(LoginRepoImpl(sl()));
  sl.registerSingleton<ArticleRepo>(ArticleRepoImpl(sl()));

  //! Usecases
  sl.registerSingleton<AuthorSignupUsecase>(AuthorSignupUsecase(sl()));
  sl.registerSingleton<AddArticleUsecase>(AddArticleUsecase(sl()));
  sl.registerSingleton<DeleteArticleUsecase>(DeleteArticleUsecase(sl()));
  sl.registerSingleton<GetArticlesUsecase>(GetArticlesUsecase(sl()));
  sl.registerSingleton<UpdateArticleUsecase>(UpdateArticleUsecase(sl()));
  sl.registerSingleton<EditorSignupUsecase>(EditorSignupUsecase(sl()));
  sl.registerSingleton<ReviewerSignupUsecase>(ReviewerSignupUsecase(sl()));
  sl.registerSingleton<LoginUsecase>(LoginUsecase(sl()));
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase(sl()));

  //! Blocs
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<ArticleBloc>(() => ArticleBloc(sl(), sl(), sl(), sl()));
}
