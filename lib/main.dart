import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:journal_web/dependency_injection.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/presentation/pages/login_page.dart';
import 'package:journal_web/features/users/presentation/bloc/users_bloc.dart';
import 'package:journal_web/firebase_options.dart';
import 'package:journal_web/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('cache');
  await initializeDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(sl(), sl(), sl(), sl(), sl())),
          BlocProvider<ArticleBloc>(
              create: (context) => ArticleBloc(sl(), sl(), sl(), sl())),
          BlocProvider<UsersBloc>(create: (context) => UsersBloc(sl(), sl()))
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginPage(),
          initialRoute: Routes.login,
          getPages: routes,
        ));
  }
}
