import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/article/presentation/pages/articles_page.dart';
import 'package:journal_web/features/home/presentation/pages/dashboard.dart';
import 'package:journal_web/features/home/presentation/pages/editorial_board_page.dart';
import 'package:journal_web/features/issue/presentation/pages/issues_page.dart';
import 'package:journal_web/features/journal/presentation/pages/journal_page.dart';
import 'package:journal_web/features/pages/presentation/pages/page_management_screen.dart';
import 'package:journal_web/features/home/presentation/pages/social_links_page.dart';
import 'package:journal_web/features/users/presentation/pages/users_page.dart';
import 'package:journal_web/features/volume/presentation/pages/all_volumes_page.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String currentIndex = 'a';
  String? indexArgument = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (indexArgument != null) {
      currentIndex = indexArgument!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> screens = {
      'd': DashboardPage(),
      'u': UsersPage(),
      'p': PageManagementPage(),
      'eb': EditorialBoardPage(),
      's': SocialLinksPage(),
      'j': JournalPage(),
      'v': AllVolumesPage(),
      'i': IssuesPage(),
      'a': ArticlesPage(),
    };

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final bool isMobile = sizingInfo.deviceScreenType == DeviceScreenType.mobile;
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(isMobile),
          drawer: isMobile ? _buildSidebar() : null,
          body: Row(
            children: [
              if (!isMobile) _buildSidebar(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue[50]!,
                        Colors.purple[50]!,
                      ],
                    ),
                  ),
                  child: screens[currentIndex] ?? screens['d']!,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ADMIN PANEL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (LoginConst.currentRole == Role.admin)
                _buildMenuItem('Dashboard', 'd', Icons.dashboard),
                if (LoginConst.currentRole == Role.admin)
                _buildMenuItem('Journals', 'j', Icons.book),
                _buildMenuItem('Volumes', 'v', Icons.collections_bookmark),
                _buildMenuItem('Issues', 'i', Icons.library_books),
                _buildMenuItem('Articles', 'a', Icons.article),
                if (LoginConst.currentRole == Role.admin)
                _buildMenuItem('Page Management', 'p', Icons.pages),
                if (LoginConst.currentRole == Role.admin)
                _buildMenuItem('Editorial Board', 'eb', Icons.people),
                if (LoginConst.currentRole == Role.admin)
                _buildMenuItem('Social Links', 's', Icons.link),
                if (LoginConst.currentRole == Role.admin)
                  _buildMenuItem('Users', 'u', Icons.person),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String route, IconData icon) {
    final isSelected = route == currentIndex;
    return ListTile(
      leading:
          Icon(icon, color: isSelected ? Colors.blue[800] : Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue[800] : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.blue[50] : null,
      onTap: () {
        setState(() {
          currentIndex = route;
        });
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading: isMobile
          ? IconButton(
              icon: Icon(Icons.menu, color: Colors.blue[800]),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            )
          : null,
      title: Text(
        'Welcome, ${LoginConst.currentUserName}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.blue[800]),
          onPressed: () {
            // Handle notifications
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.person),
            label: Text('Profile'),
            onPressed: () {
              Get.toNamed(Routes.profile);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
