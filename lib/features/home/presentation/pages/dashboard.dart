import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildSectionTitle('Content'),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('Pages', 'pages')),
                          SizedBox(width: 16),
                          Expanded(child: _buildInfoCard('Articles', 'articles')),
                        ],
                      ),
                      SizedBox(height: 24),
                      _buildSectionTitle('Publications'),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('Journals', 'journals')),
                          SizedBox(width: 16),
                          Expanded(child: _buildInfoCard('Volumes', 'volumes')),
                          SizedBox(width: 16),
                          Expanded(child: _buildInfoCard('Issues', 'issues')),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSectionTitle('People'),
                      SizedBox(height: 16),
                      _buildInfoCard('Users', 'users'),
                      SizedBox(height: 16),
                      _buildInfoCard('Editorial Board', 'editorialBoard'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoCard('Pages', 'pages'),
            SizedBox(height: 16),
            _buildInfoCard('Users', 'users'),
            SizedBox(height: 16),
            _buildInfoCard('Articles', 'articles'),
            SizedBox(height: 16),
            _buildInfoCard('Editorial Board', 'editorialBoard'),
            SizedBox(height: 16),
            _buildInfoCard('Journals', 'journals'),
            SizedBox(height: 16),
            _buildInfoCard('Volumes', 'volumes'),
            SizedBox(height: 16),
            _buildInfoCard('Issues', 'issues'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        int count = snapshot.data?.docs.length ?? 0;
        Color color;
        IconData icon;

        switch (collection) {
          case 'pages':
            color = Colors.blue;
            icon = Icons.pages;
            break;
          case 'users':
            color = Colors.green;
            icon = Icons.people;
            break;
          case 'articles':
            color = Colors.orange;
            icon = Icons.article;
            break;
          case 'editorialBoard':
            color = Colors.purple;
            icon = Icons.group;
            break;
          case 'journals':
            color = Colors.red;
            icon = Icons.book;
            break;
          case 'volumes':
            color = Colors.teal;
            icon = Icons.collections_bookmark;
            break;
          case 'issues':
            color = Colors.amber;
            icon = Icons.library_books;
            break;
          default:
            color = Colors.grey;
            icon = Icons.error;
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Icon(icon, size: 32, color: color),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    count.toString(),
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total ${title.toLowerCase()}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
