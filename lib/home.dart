import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:journal_web/features/home/presentation/pages/dashboard.dart';
import 'package:journal_web/features/home/presentation/pages/editorial_board_page.dart';
import 'package:journal_web/features/pages/presentation/pages/page_management_screen.dart';
import 'package:journal_web/features/home/presentation/pages/social_links_page.dart';
import 'package:journal_web/features/users/presentation/pages/users_page.dart';
import 'package:journal_web/features/volume/presentation/pages/volume_home.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = Get.parameters['i'] ?? '/dashboard';

    final Map<String, Widget> screens = {
      '/dashboard': DashboardPage(),
      '/volumes': VolumeHomePage(),
      '/users': UsersPage(),
      '/pages': PageManagementPage(),
      '/editorial_board': EditorialBoardPage(),
      '/social': SocialLinksPage(),
    };
    return ResponsiveBuilder(builder: (context, sizingInfo) {
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
              title: 'Volumes',
              route: '/volumes',
              icon: Icons.book,
            ),
            AdminMenuItem(
              title: 'Page Management',
              route: '/pages',
              icon: Icons.book,
            ),
            AdminMenuItem(
              title: 'Editorial Board',
              route: '/editorial_board',
              icon: Icons.people,
            ),
            AdminMenuItem(
              title: 'Social Links',
              route: '/social',
              icon: Icons.people,
            ),
            AdminMenuItem(
              title: 'Users',
              route: '/users',
              icon: Icons.people,
            )
          ],
          selectedRoute: currentIndex,
          onSelected: (item) {
            if (item.route != null) {
              Get.offAllNamed(Routes.dashboard, parameters: {'i': item.route!});
            }
          },
          activeTextStyle: TextStyle(color: Colors.white),
          activeBackgroundColor: Colors.blue,
        ),
        body: screens[currentIndex] ?? Center(child: Text('No screen found')),
      );
    });
  }
}
