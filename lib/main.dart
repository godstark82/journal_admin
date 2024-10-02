import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/dependency_injection.dart';
import 'package:journal_web/features/login/presentation/bloc/login_bloc.dart';
import 'package:journal_web/features/login/presentation/pages/login_page.dart';
import 'package:journal_web/features/users/presentation/bloc/users_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/article/article_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/article/singlearticle/singlearticle_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/issue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/singleissue/singleissue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/singlevolume/singlevolume_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/volume_bloc.dart';
import 'package:journal_web/firebase_options.dart';
import 'package:journal_web/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('cache');
  await initializeDependencies();
  await LoginConst.getCurrentUser();
  runApp(const MainApp());
}
// 09GsUfOiI1SKwdU3ZT7G -VI
// 2JhAfZEI9ZqGtc5uZNBw -II

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<VolumeBloc>(create: (context) => sl<VolumeBloc>()),
          BlocProvider<IssueBloc>(create: (context) => sl<IssueBloc>()),
          BlocProvider<ArticleBloc>(create: (context) => sl<ArticleBloc>()),
          BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
          BlocProvider<UsersBloc>(create: (context) => sl<UsersBloc>()),
          BlocProvider<SinglearticleBloc>(
              create: (context) => sl<SinglearticleBloc>()),
          BlocProvider<SingleissueBloc>(
              create: (context) => sl<SingleissueBloc>()),
          BlocProvider<SinglevolumeBloc>(
              create: (context) => sl<SinglevolumeBloc>()),
        ],
        child: GetMaterialApp(
          defaultTransition: Get.defaultTransition,
          transitionDuration: const Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
          home: LoginPage(),

          initialRoute: Routes.dashboard,
          getPages: routes,
        ));
  }
}
