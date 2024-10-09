import 'package:get_it/get_it.dart';
import 'package:journal_web/features/article/data/repositories/article_repo_impl.dart';
import 'package:journal_web/features/article/domain/repositories/article_repo.dart';
import 'package:journal_web/features/article/domain/usecases/add_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/delete_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/edit_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_all_article_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_id_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_iid_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_jid_uc.dart';
import 'package:journal_web/features/article/domain/usecases/get_article_by_vid_uc.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/issue/data/repositories/issue_repo_impl.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';
import 'package:journal_web/features/issue/domain/usecases/add_issue_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/delete_issue_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_all_issue_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_issue_by_id_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_issue_by_vid_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/get_issues_by_jid_uc.dart';
import 'package:journal_web/features/issue/domain/usecases/update_issue_uc.dart';
import 'package:journal_web/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:journal_web/features/journal/data/repositories/journal_repo_impl.dart';
import 'package:journal_web/features/journal/domain/repositories/journal_repo.dart';
import 'package:journal_web/features/journal/domain/usecases/create_journal_usecase.dart';
import 'package:journal_web/features/journal/domain/usecases/delete_journal_usecase.dart';
import 'package:journal_web/features/journal/domain/usecases/get_all_journal_uc.dart';
import 'package:journal_web/features/journal/domain/usecases/get_journal_uc.dart';
import 'package:journal_web/features/journal/domain/usecases/update_journal_usecase.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
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
import 'package:journal_web/features/users/domain/usecases/update_user_journals_uc.dart';
import 'package:journal_web/features/users/presentation/bloc/users_bloc.dart';
import 'package:journal_web/features/volume/data/repositories/volume_repo_impl.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';
import 'package:journal_web/features/volume/domain/usecases/create_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/delete_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/get_all_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/get_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/get_vby_jid_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/update_v_uc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';

import 'package:journal_web/services/article/article_service.dart';
import 'package:journal_web/services/issue_services.dart';
import 'package:journal_web/services/journal_services.dart';
import 'package:journal_web/services/login/login_service.dart';
import 'package:journal_web/services/page_service.dart';
import 'package:journal_web/services/users_service.dart';
import 'package:journal_web/services/volume_services.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //! Services
  sl.registerSingleton<LoginService>(LoginService());
  sl.registerSingleton<UsersService>(UsersService());
  sl.registerSingleton<ArticleService>(ArticleService());
  sl.registerSingleton<PageService>(PageService());
  sl.registerSingleton<JournalServices>(JournalServices());
  sl.registerSingleton<VolumeServices>(VolumeServices());
  sl.registerSingleton<IssueServices>(IssueServices());


  //! Repositories
  sl.registerSingleton<LoginRepo>(LoginRepoImpl(sl()));
  sl.registerSingleton<UsersRepo>(UsersRepoImpl(sl()));
  sl.registerSingleton<PagesRepo>(PagesRepoImpl(sl()));
  sl.registerSingleton<JournalRepo>(JournalRepoImpl(sl()));
  sl.registerSingleton<VolumeRepo>(VolumeRepoImpl(sl()));
  sl.registerSingleton<IssueRepository>(IssueRepoImpl(sl()));
  sl.registerSingleton<ArticleRepository>(ArticleRepoImpl(sl()));

  //! Usecases

  //? Journal Usecases
  sl.registerSingleton<GetJournalUc>(GetJournalUc(sl()));
  sl.registerSingleton<GetAllJournalUC>(GetAllJournalUC(sl()));
  sl.registerSingleton<DeleteJournalUsecase>(DeleteJournalUsecase(sl()));
  sl.registerSingleton<CreateJournalUsecase>(CreateJournalUsecase(sl()));
  sl.registerSingleton<UpdateJournalUsecase>(UpdateJournalUsecase(sl()));

  //? Volume Usecases
  sl.registerSingleton<CreateVolumeUC>(CreateVolumeUC(sl()));
  sl.registerSingleton<UpdateVolumeUC>(UpdateVolumeUC(sl()));
  sl.registerSingleton<DeleteVolumeUC>(DeleteVolumeUC(sl()));
  sl.registerSingleton<GetVolumeUseCase>(GetVolumeUseCase(sl()));
  sl.registerSingleton<GetVolumesByJournalIdUC>(GetVolumesByJournalIdUC(sl()));
  sl.registerSingleton<GetAllVolumesUseCase>(GetAllVolumesUseCase(sl()));

  //? Issue Usecases
  sl.registerSingleton<GetAllIssueUC>(GetAllIssueUC(sl()));
  sl.registerSingleton<GetIssueByIdUseCase>(GetIssueByIdUseCase(sl()));
  sl.registerSingleton<GetIssueByVolumeIdUseCase>(
      GetIssueByVolumeIdUseCase(sl()));
  sl.registerSingleton<GetIssuesByJournalIdUseCase>(
      GetIssuesByJournalIdUseCase(sl()));
  sl.registerSingleton<AddIssueUseCase>(AddIssueUseCase(sl()));
  sl.registerSingleton<UpdateIssueUseCase>(UpdateIssueUseCase(sl()));
  sl.registerSingleton<DeleteIssueUseCase>(DeleteIssueUseCase(sl()));

  //? Article Usecases
  sl.registerSingleton<GetAllArticleUC>(GetAllArticleUC(sl()));
  sl.registerSingleton<GetArticleByIssueIdUC>(GetArticleByIssueIdUC(sl()));
  sl.registerSingleton<GetArticleByVolumeIdUC>(GetArticleByVolumeIdUC(sl()));
  sl.registerSingleton<GetArticleByJournalIdUC>(GetArticleByJournalIdUC(sl()));
  sl.registerSingleton<GetArticleByIdUC>(GetArticleByIdUC(sl()));
  sl.registerSingleton<AddArticleUC>(AddArticleUC(sl()));
  sl.registerSingleton<EditArticleUc>(EditArticleUc(sl()));
  sl.registerSingleton<DeleteArticleUC>(DeleteArticleUC(sl()));

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
  sl.registerSingleton<UpdateUserJournalsUC>(UpdateUserJournalsUC(sl()));

  //! Blocs
  sl.registerFactory<JournalBloc>(
      () => JournalBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<PagesBloc>(() => PagesBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<UsersBloc>(() => UsersBloc(sl(), sl(), sl()));
  sl.registerFactory<IssueBloc>(
      () => IssueBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<VolumeBloc>(
      () => VolumeBloc(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<ArticleBloc>(
      () => ArticleBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
}
