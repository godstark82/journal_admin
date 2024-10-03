import 'package:flutter/material.dart';
import 'package:journal_web/features/pages/data/datasources/pages_data.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildInfoCard('Pages', '10', Colors.blue, Icons.pages)),
          SizedBox(width: 16),
          Expanded(child: _buildInfoCard('Users', '100', Colors.green, Icons.people)),
          SizedBox(width: 16),
          Expanded(child: _buildInfoCard('Articles', '50', Colors.orange, Icons.article)),
          SizedBox(width: 16),
          Expanded(child: _buildInfoCard('Editorial Board', '20', Colors.purple, Icons.group)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoCard('Pages', websitePages.length.toString(), Colors.blue, Icons.pages),
            SizedBox(height: 16),
            _buildInfoCard('Users', '100', Colors.green, Icons.people),
            SizedBox(height: 16),
            _buildInfoCard('Articles', '50', Colors.orange, Icons.article),
            SizedBox(height: 16),
            _buildInfoCard('Editorial Board', '20', Colors.purple, Icons.group),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String count, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Icon(icon, size: 48, color: color),
          ],
        ),
      ),
    );
  }
}

