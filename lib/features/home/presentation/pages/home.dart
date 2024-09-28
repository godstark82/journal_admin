import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:journal_web/features/article/presentation/pages/article_page.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, Widget> screens = {
    '/dashboard': Center(child: Text('Dashboard')),
    '/articles': ArticlePage(),
  };
  String currentIndex = '/dashboard';
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      // if (sizingInfo.isDesktop || sizingInfo.isTablet) {
      return AdminScaffold(
        appBar: AppBar(
          title: Text('ADMIN HOME'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GFButton(
                
                icon: Icon(Icons.person),
                text: 'Profile',
                onPressed: () {
                  Get.toNamed(Routes.profile);
                },
              ),
            )
          ],
        ),
        sideBar: SideBar(
          items: const [
            AdminMenuItem(
              title: 'Dashboard',
              route: '/dashboard',
              icon: Icons.dashboard,
            ),
            AdminMenuItem(
              title: 'articles',
              route: '/articles',
              icon: Icons.article,
            )
          ],
          selectedRoute: currentIndex,
          onSelected: (item) {
            if (item.route != null) {
              currentIndex = item.route!;
              setState(() {});
            }
          },
          activeBackgroundColor: Colors.blue,
        ),
        body: screens[currentIndex] ?? Center(child: Text('No screen found')),
      );
      // }
    });
  }
}
