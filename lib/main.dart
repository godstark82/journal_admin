import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/dependency_injection.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/presentation/pages/login_page.dart';
import 'package:journal_web/features/pages/presentation/bloc/pages_bloc.dart';
import 'package:journal_web/features/users/presentation/bloc/users_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/firebase_options.dart';
import 'package:journal_web/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('cache');
  await initializeDependencies();
  await LoginConst.getCurrentUser();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
          BlocProvider<UsersBloc>(create: (context) => sl<UsersBloc>()),
          BlocProvider<PagesBloc>(create: (context) => sl<PagesBloc>()),
          BlocProvider<JournalBloc>(create: (context) => sl<JournalBloc>()),
          BlocProvider<VolumeBloc>(create: (context) => sl<VolumeBloc>()),
          BlocProvider<IssueBloc>(create: (context) => sl<IssueBloc>()),
          BlocProvider<ArticleBloc>(create: (context) => sl<ArticleBloc>()),
        ],
        child: GetMaterialApp(
          defaultTransition: Get.defaultTransition,
          transitionDuration: const Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
          home: LoginPage(),
          initialRoute: Routes.login,
          getPages: routes,
        ));
  }
}
