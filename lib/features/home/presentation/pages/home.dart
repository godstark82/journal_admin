import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      // if (sizingInfo.isDesktop || sizingInfo.isTablet) {
      return AdminScaffold(
          appBar: AppBar(
            title: Text('ADMIN HOME'),
            actions: [
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Get.toNamed(Routes.profile);
                },
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
                title: 'Top Level',
                icon: Icons.file_copy,
                children: [
                  AdminMenuItem(
                    title: 'Second Level Item 1',
                    route: '/journal',
                  ),
                  AdminMenuItem(
                    title: 'Second Level Item 2',
                    route: '/secondLevelItem2',
                  ),
                  AdminMenuItem(
                    title: 'Third Level',
                    children: [
                      AdminMenuItem(
                        title: 'Third Level Item 1',
                        route: '/thirdLevelItem1',
                      ),
                      AdminMenuItem(
                        title: 'Third Level Item 2',
                        route: '/thirdLevelItem2',
                      ),
                    ],
                  ),
                ],
              ),
            ],
            selectedRoute: '/dashboard',
            onSelected: (item) {
              if (item.route != null) {
                // Navigator.of(context).pushNamed(item.route!);
              }
            },
          ),
          body: Center(
            child: Text('ADMIN'),
          ));
      // }
    });
  }
}
