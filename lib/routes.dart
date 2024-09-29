import 'package:get/get.dart';
import 'package:journal_web/core/common/screens/profile.dart';
import 'package:journal_web/features/article/presentation/pages/add_article_page.dart';
import 'package:journal_web/features/article/presentation/pages/edit_article_page.dart';
import 'package:journal_web/features/home/presentation/pages/home.dart';
import 'package:journal_web/features/login/presentation/pages/login_page.dart';
import 'package:journal_web/features/login/presentation/pages/registration/author_signup.dart';
import 'package:journal_web/features/login/presentation/pages/registration/editor_signup.dart';
import 'package:journal_web/features/login/presentation/pages/registration/reviewer_signup.dart';

class Routes {
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String addArticle = '/add_article';
  static const String editorSignup = '/editor_signup';
  static const String authorSignup = '/author_signup';
  static const String reviewerSignup = '/reviewer_signup';
  static const String editArticle = '/edit_article';
}

List<GetPage> routes = [
  //! Home / Dashboard
  GetPage(
    name: Routes.dashboard,
    page: () => Home(),
    children: [
      GetPage(name: Routes.addArticle, page: () => AddArticlePage()),
      GetPage(
        name: Routes.editArticle,
        page: () => EditArticlePage(article: Get.arguments['article']),
      ),
    ],
  ),

  //! Login Page Initial Page
  GetPage(name: Routes.login, page: () => LoginPage()),
  GetPage(name: Routes.profile, page: () => ProfilePage()),
  //! Registration Page
  GetPage(name: Routes.editorSignup, page: () => EditorSignup()),
  GetPage(name: Routes.authorSignup, page: () => AuthorSignup()),
  GetPage(name: Routes.reviewerSignup, page: () => ReviewerSignup()),
];
