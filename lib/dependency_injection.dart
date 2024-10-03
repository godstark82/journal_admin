import 'package:get_it/get_it.dart';
import 'package:journal_web/features/login/data/repositories/login_repo_impl.dart';
import 'package:journal_web/features/login/domain/repositories/login_repo.dart';
import 'package:journal_web/features/login/domain/usecases/author_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/editor_signup_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/login_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/logout_usecase.dart';
import 'package:journal_web/features/login/domain/usecases/reviewer_signup_usecase.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/pages/data/repositories/pages_repo_impl.dart';
import 'package:journal_web/features/pages/domain/repositories/pages_repo.dart';
import 'package:journal_web/features/pages/domain/usecases/add_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/delete_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/edit_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/get_page_usecase.dart';
import 'package:journal_web/features/pages/domain/usecases/get_pages_usecase.dart';
import 'package:journal_web/features/pages/presentation/bloc/pages_bloc.dart';
import 'package:journal_web/features/users/data/repositories/users_repo_impl.dart';
import 'package:journal_web/features/users/domain/repositories/users_repo.dart';
import 'package:journal_web/features/users/domain/usecases/get_all_users_usecase.dart';
import 'package:journal_web/features/users/domain/usecases/get_specific_user_usecase.dart';
import 'package:journal_web/features/users/presentation/bloc/users_bloc.dart';
import 'package:journal_web/features/volume/data/repositories/volume_repo_impl.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';
import 'package:journal_web/features/volume/domain/usecases/article_usecase.dart';
import 'package:journal_web/features/volume/domain/usecases/issue_usecases.dart';
import 'package:journal_web/features/volume/domain/usecases/volume_usecases.dart';
import 'package:journal_web/features/volume/presentation/bloc/article/article_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/article/singlearticle/singlearticle_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/issue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/singleissue/singleissue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/singlevolume/singlevolume_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/volume_bloc.dart';
import 'package:journal_web/services/article/article_service.dart';
import 'package:journal_web/services/login/login_service.dart';
import 'package:journal_web/services/page_service.dart';
import 'package:journal_web/services/users_service.dart';
import 'package:journal_web/services/volume_services.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //! Services
  sl.registerSingleton<VolumeServices>(VolumeServices());
  sl.registerSingleton<LoginService>(LoginService());
  sl.registerSingleton<UsersService>(UsersService());
  sl.registerSingleton<ArticleService>(ArticleService());
  sl.registerSingleton<PageService>(PageService());

  //! Repositories
  sl.registerSingleton<VolumeRepo>(VolumeRepoImpl(sl()));
  sl.registerSingleton<LoginRepo>(LoginRepoImpl(sl()));
  sl.registerSingleton<UsersRepo>(UsersRepoImpl(sl()));
  sl.registerSingleton<PagesRepo>(PagesRepoImpl(sl()));

  //! Usecases
  //? Volume Usecases
  sl.registerSingleton<GetVolumeByIdUseCase>(GetVolumeByIdUseCase(sl()));
  sl.registerSingleton<GetAllVolumeUseCase>(GetAllVolumeUseCase(sl()));
  sl.registerSingleton<DeleteVolumeUseCase>(DeleteVolumeUseCase(sl()));
  sl.registerSingleton<CreateVolumeUseCase>(CreateVolumeUseCase(sl()));
  sl.registerSingleton<UpdateVolumeUseCase>(UpdateVolumeUseCase(sl()));

  sl.registerSingleton<GetArticleByIdUseCase>(GetArticleByIdUseCase(sl()));
  sl.registerSingleton<CreateArticleUseCase>(CreateArticleUseCase(sl()));
  sl.registerSingleton<GetArticlesByIssueIdUseCase>(
      GetArticlesByIssueIdUseCase(sl()));
  sl.registerSingleton<DeleteArticleUseCase>(DeleteArticleUseCase(sl()));
  sl.registerSingleton<UpdateArticleUseCase>(UpdateArticleUseCase(sl()));

  sl.registerSingleton<GetAllIssueUseCase>(GetAllIssueUseCase(sl()));
  sl.registerSingleton<GetIssueByIdUseCase>(GetIssueByIdUseCase(sl()));
  sl.registerSingleton<DeleteIssueUseCase>(DeleteIssueUseCase(sl()));
  sl.registerSingleton<CreateIssueUseCase>(CreateIssueUseCase(sl()));
  sl.registerSingleton<UpdateIssueUseCase>(UpdateIssueUseCase(sl()));

  //? Login Usecases
  sl.registerSingleton<AuthorSignupUsecase>(AuthorSignupUsecase(sl()));
  sl.registerSingleton<EditorSignupUsecase>(EditorSignupUsecase(sl()));
  sl.registerSingleton<ReviewerSignupUsecase>(ReviewerSignupUsecase(sl()));
  sl.registerSingleton<LoginUsecase>(LoginUsecase(sl()));
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase(sl()));
  sl.registerSingleton<GetAllUsersUseCase>(GetAllUsersUseCase(sl()));
  sl.registerSingleton<GetSpecificUserUsecase>(GetSpecificUserUsecase(sl()));

  //! Pages Usecases
  sl.registerSingleton<GetSinglePageUsecase>(GetSinglePageUsecase(sl()));
  sl.registerSingleton<GetPagesUsecase>(GetPagesUsecase(sl()));
  sl.registerSingleton<EditPageUsecase>(EditPageUsecase(sl()));
  sl.registerSingleton<DeletePageUsecase>(DeletePageUsecase(sl()));
  sl.registerSingleton<AddPageUsecase>(AddPageUsecase(sl()));

  //! Blocs
  sl.registerFactory<PagesBloc>(() => PagesBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<VolumeBloc>(
      () => VolumeBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<SinglevolumeBloc>(() => SinglevolumeBloc(sl()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<IssueBloc>(() => IssueBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<ArticleBloc>(
      () => ArticleBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<UsersBloc>(() => UsersBloc(sl(), sl()));
  sl.registerFactory<SingleissueBloc>(() => SingleissueBloc(sl()));
  sl.registerFactory<SinglearticleBloc>(() => SinglearticleBloc(sl()));
}
