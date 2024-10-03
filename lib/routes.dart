import 'package:get/get.dart';
import 'package:journal_web/core/common/screens/profile.dart';
import 'package:journal_web/core/usecase/middleware.dart';
import 'package:journal_web/features/home/presentation/pages/add_editorial.dart';
import 'package:journal_web/features/home/presentation/pages/edit_editorial.dart';
import 'package:journal_web/features/pages/presentation/pages/add_page.dart';
import 'package:journal_web/features/pages/presentation/pages/edit_page.dart';
import 'package:journal_web/features/pages/presentation/pages/view_page.dart';
import 'package:journal_web/features/volume/presentation/pages/add/add_article.dart';
import 'package:journal_web/features/volume/presentation/pages/add/add_issue.dart';
import 'package:journal_web/features/volume/presentation/pages/add/add_volume.dart';
import 'package:journal_web/features/volume/presentation/pages/edit/edit_article.dart';
import 'package:journal_web/features/volume/presentation/pages/edit/edit_issue.dart';
import 'package:journal_web/features/volume/presentation/pages/edit/edit_volume.dart';
import 'package:journal_web/features/volume/presentation/pages/view/comments_page.dart';
import 'package:journal_web/features/volume/presentation/pages/view/view_article.dart';
import 'package:journal_web/features/volume/presentation/pages/view/view_issue.dart';
import 'package:journal_web/features/volume/presentation/pages/view/view_volume.dart';
import 'package:journal_web/features/volume/presentation/pages/volume_home.dart';
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

  //volume related
  static const String volumes = '/volumes';
  static const String addVolume = '/add_volume';
  static const String editVolume = '/edit_volume';
  static const String viewVolume = '/view_volume';

  static const String addIssue = '/add_issue';
  static const String viewIssue = '/view_issue';
  static const String editIssue = '/edit_issue';
  static const String addArticle = '/add_article';
  static const String viewArticle = '/view_article';
  static const String editArticle = '/edit_article';
  static const String comments = '/comments';


  //ADMIN
  static const String editorialBoard = '/editorial_board';
  static const String addEditorialBoard = '/add_editorial_board';
  static const String editEditorialBoard = '/edit_editorial_board';

  // Pages
  static const String pages = '/pages';
  static const String addPage = '/add_page';
  static const String editPage = '/edit_page';
  static const String viewPage = '/view_page';
}

List<GetPage> routes = [
  //! Home / Dashboard
  GetPage(
      name: Routes.dashboard,
      parameters: {'i': ''},
      middlewares: [AuthGuard()],
      page: () => Home(),
      children: [
        GetPage(
          name: Routes.volumes,
          page: () => VolumeHomePage(),
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: Routes.addVolume,
          page: () => AddVolumePage(),
          middlewares: [AuthGuard()],
        ),
        GetPage(
            name: Routes.viewVolume,
            page: () => ViewVolumePage(),
            middlewares: [AuthGuard()],
            children: []),
      ]),

  GetPage(
    name: '${Routes.dashboard}${Routes.viewVolume}${Routes.addIssue}',
    page: () => AddIssuePage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '${Routes.dashboard}${Routes.viewVolume}${Routes.editVolume}',
    page: () => EditVolumePage(),
    parameters: {'volumeId': ''},
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}',
    page: () => ViewIssuePage(),
    parameters: {'issueId': '', 'volumeId': ''},
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name:
        '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}${Routes.editIssue}',
    page: () => EditIssuePage(),
    parameters: {'issueId': '', 'volumeId': ''},
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name:
        '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}${Routes.addArticle}',
    page: () => AddArticlePage(),
    parameters: {'issueId': '', 'volumeId': ''},
    middlewares: [AuthGuard()],
  ),

  GetPage(
    name:
        '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}${Routes.editArticle}',
    page: () => EditArticlePage(),
    parameters: {'issueId': '', 'volumeId': '', 'articleId': ''},
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name:
        '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}${Routes.viewArticle}',
    page: () => ViewArticlePage(),
    parameters: {'issueId': '', 'volumeId': '', 'articleId': ''},
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name:
        '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}${Routes.viewArticle}${Routes.comments}',
    page: () => CommentsPage(),
    parameters: {'issueId': '', 'volumeId': '', 'articleId': ''},
    middlewares: [AuthGuard()],
  ),

  //! ADMIN BASED ROUTES
  GetPage(
      name: Routes.editorialBoard,
      page: () => Home(),
      parameters: {'i': '/editorial_board'}),
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
    name: Routes.pages + Routes.viewPage,
    page: () => ViewPage(),
    parameters: {'pageId': ''},
    middlewares: [AuthGuard()],
  ),

  GetPage(
    name: Routes.pages + Routes.editPage,
    page: () => EditPage(),
    parameters: {'pageId': ''},
    middlewares: [AuthGuard()],
  ),

  GetPage(
    name: Routes.pages + Routes.addPage,
    page: () => AddPage(),
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
