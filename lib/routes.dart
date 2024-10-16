import 'package:get/get.dart';
import 'package:journal_web/core/common/screens/profile.dart';
import 'package:journal_web/core/usecase/middleware.dart';
import 'package:journal_web/features/article/presentation/pages/add_article_page.dart';
import 'package:journal_web/features/article/presentation/pages/edit_article_page.dart';
import 'package:journal_web/features/home/presentation/pages/add_editorial.dart';
import 'package:journal_web/features/home/presentation/pages/edit_editorial.dart';
import 'package:journal_web/features/home/presentation/pages/editorial_board_page.dart';
import 'package:journal_web/features/issue/presentation/pages/add_issue_page.dart';
import 'package:journal_web/features/issue/presentation/pages/edit_issue_page.dart';
import 'package:journal_web/features/journal/presentation/pages/add_journal_page.dart';
import 'package:journal_web/features/journal/presentation/pages/edit_journal_page.dart';
import 'package:journal_web/features/journal/presentation/pages/journal_page.dart';
import 'package:journal_web/features/pages/presentation/pages/add_page.dart';
import 'package:journal_web/features/pages/presentation/pages/all_pages_screen.dart';
import 'package:journal_web/features/pages/presentation/pages/edit_page.dart';
import 'package:journal_web/features/volume/presentation/pages/add_volume_page.dart';
import 'package:journal_web/features/volume/presentation/pages/all_volumes_page.dart';
import 'package:journal_web/features/volume/presentation/pages/edit_volume_page.dart';
import 'package:journal_web/home.dart';
import 'package:journal_web/features/login/presentation/pages/login_page.dart';
import 'package:journal_web/features/login/presentation/pages/registration/author_signup.dart';
import 'package:journal_web/features/login/presentation/pages/registration/editor_signup.dart';
import 'package:journal_web/features/login/presentation/pages/registration/reviewer_signup.dart';

class Routes {
  //login related
  static const String login = '/login';
  static const String editorSignup = '/editor_signup';
  static const String authorSignup = '/author_signup';
  static const String reviewerSignup = '/reviewer_signup';

  //dashboard related
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  //ADMIN
  static const String editorialBoard = '/editorial_board';
  static const String addEditorialBoard = '/add_editorial_board';
  static const String editEditorialBoard = '/edit_editorial_board';

  // Pages
  static const String pages = '/pages';
  static const String addPage = '/add_page';
  static const String editPage = '/edit_page';
  static const String allPages = '/all_pages';

  // Journal
  static const String journal = '/journal';
  static const String addJournal = '/add_journal';
  static const String editJournal = '/edit_journal';

  // Volume
  static const String volume = '/volume';
  static const String addVolume = '/add_volume';
  static const String editVolume = '/edit_volume';

  // Issue
  static const String issue = '/issue';
  static const String addIssue = '/add_issue';
  static const String editIssue = '/edit_issue';

  // Article
  static const String article = '/article';
  static const String addArticle = '/add_article';
  static const String editArticle = '/edit_article';
}

List<GetPage> routes = [
  GetPage(
      name: Routes.dashboard, middlewares: [AuthGuard()], page: () => Home()),

  //! Journal
  GetPage(
      name: Routes.dashboard + Routes.journal,
      page: () => JournalPage(),
      middlewares: [AuthGuard()]),
  GetPage(
      name: Routes.dashboard + Routes.addJournal,
      page: () => AddJournalPage(),
      middlewares: [AuthGuard()]),
  GetPage(
      name: Routes.dashboard + Routes.editJournal,
      page: () => EditJournalPage(),
      middlewares: [AuthGuard()]),

  //! Volume
  GetPage(
      name: Routes.dashboard + Routes.addVolume,
      page: () => AddVolumePage(),
      middlewares: [AuthGuard()]),

  GetPage(
      name: Routes.dashboard + Routes.editVolume,
      page: () => EditVolumePage(),
      middlewares: [AuthGuard()]),

  //! Issue
  GetPage(
      name: Routes.dashboard + Routes.addIssue,
      page: () => AddIssuePage(),
      middlewares: [AuthGuard()]),

  GetPage(
      name: Routes.dashboard + Routes.editIssue,
      page: () => EditIssuePage(),
      middlewares: [AuthGuard()]),

  //! Article
  GetPage(
      name: Routes.dashboard + Routes.addArticle,
      page: () => AddArticlePage(),
      middlewares: [AuthGuard()]),

  GetPage(
      name: Routes.dashboard + Routes.editArticle,
      page: () => EditArticlePage(),
      middlewares: [AuthGuard()]),

  //! ADMIN BASED ROUTES
  GetPage(
      name: Routes.editorialBoard,
      page: () => Home(),
      parameters: {'i': '/editorial_board'}),

  GetPage(
    name: Routes.dashboard + Routes.editorialBoard,
    page: () => EditorialBoardPage(),
    parameters: {'journalId': ''},
    middlewares: [AuthGuard()],
  ),

  GetPage(
    name: Routes.editorialBoard + Routes.addEditorialBoard,
    page: () => AddEditorialPage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
      name: Routes.editorialBoard + Routes.editEditorialBoard,
      page: () => EditEditorialPage(),
      parameters: {'memberId': ''}),
  GetPage(
    name: Routes.pages + Routes.editPage,
    page: () => EditPage(),
    parameters: {'pageId': '', 'journalId': ''},
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.pages + Routes.allPages,
    page: () => AllPagesPage(),
    parameters: {'journalId': ''},
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.pages + Routes.addPage,
    page: () => AddPage(),
    parameters: {'journalId': ''},
    middlewares: [AuthGuard()],
  ),

  //! Login Page Initial Page
  GetPage(name: Routes.login, page: () => LoginPage()),
  GetPage(
    name: Routes.profile,
    page: () => ProfilePage(),
    middlewares: [AuthGuard()],
  ),
  //! Registration Page
  GetPage(name: Routes.editorSignup, page: () => EditorSignup()),
  GetPage(name: Routes.authorSignup, page: () => AuthorSignup()),
  GetPage(name: Routes.reviewerSignup, page: () => ReviewerSignup()),
];
