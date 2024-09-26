import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/dependency_injection.dart';
import 'package:journal_web/features/home/presentation/pages/home.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/presentation/pages/login_page.dart';
import 'package:journal_web/features/login/presentation/pages/registration/author_signup.dart';
import 'package:journal_web/features/login/presentation/pages/registration/editor_signup.dart';
import 'package:journal_web/features/login/presentation/pages/registration/reviewer_signup.dart';
import 'package:journal_web/firebase_options.dart';
import 'package:journal_web/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(sl(), sl(), sl(),sl())),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        initialRoute: Routes.login,
        getPages: routes,
      ),
    );
  }
}

List<GetPage> routes = [
  //! Home / Dashboard
  GetPage(name: Routes.dashboard, page: () => Home()),

  //! Login Page Initial Page
  GetPage(name: Routes.login, page: () => LoginPage()),

  //! Registration Page
  GetPage(name: Routes.editorSignup, page: () => EditorSignup()),
  GetPage(name: Routes.authorSignup, page: () => AuthorSignup()),
  GetPage(name: Routes.reviewerSignup, page: () => ReviewerSignup()),
];
