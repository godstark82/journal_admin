import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/singleissue/singleissue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/issue/issue_bloc.dart';
import 'package:journal_web/features/volume/presentation/widgets/article_card.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ViewIssuePage extends StatefulWidget {
  const ViewIssuePage({super.key});

  @override
  _ViewIssuePageState createState() => _ViewIssuePageState();
}

class _ViewIssuePageState extends State<ViewIssuePage> {
  String issueId = Get.parameters['issueId']!;
  String volumeId = Get.parameters['volumeId']!;

  @override
  void initState() {
    super.initState();
    log('issueId: $issueId');
    log('volumeId: $volumeId');
    _loadIssueData();
  }

  void _loadIssueData() {
    if (issueId.isNotEmpty && volumeId.isNotEmpty) {
      context
          .read<SingleissueBloc>()
          .add(LoadSingleIssueEvent(issueId: issueId, volumeId: volumeId));
    }
  }

  void _showDeleteConfirmation(BuildContext context, IssueModel issue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text('Delete Issue', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_forever, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text(
                'Are you sure you want to delete this issue?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          backgroundColor: Colors.yellow[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteIssue(issue);
              },
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteIssue(IssueModel issue) {
    context.read<IssueBloc>().add(DeleteIssueEvent(
          issueId: issue.id!,
          volumeId: volumeId,
        ));
    Get.offNamed('${Routes.dashboard}${Routes.viewVolume}',
        parameters: {'volumeId': volumeId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SingleissueBloc, SingleissueState>(
        builder: (context, state) {
          if (state is SingleIssueLoaded) {
            IssueModel issue = state.issue;
            return Scaffold(
              appBar: AppBar(
                title: Text('Issue ${issue.issueNumber}'),
                backgroundColor: Colors.teal[700],
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(context, issue);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete Issue',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                    icon: Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.grey[100],
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 600
                      ? MediaQuery.of(context).size.width * 0.1
                      : 16,
                  vertical: 16,
                ),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                issue.title ?? '',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.edit, color: Colors.white),
                              label: Text('Edit Details'),
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}${Routes.editIssue}',
                                  parameters: {
                                    'issueId': issueId,
                                    'volumeId': volumeId,
                                  },
                                );
                                if (result == true) {
                                  _loadIssueData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        ResponsiveBuilder(
                          builder: (context, sizingInformation) {
                            return Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                _buildInfoCard(
                                    'Issue Number',
                                    issue.issueNumber.toString(),
                                    Icons.confirmation_number,
                                    Colors.blue),
                                _buildInfoCard(
                                    'From Date',
                                    issue.fromDate != null
                                        ? DateFormat('dd-MMM-yyyy')
                                            .format(issue.fromDate!)
                                        : 'Not set',
                                    Icons.date_range,
                                    Colors.green),
                                _buildInfoCard(
                                    'To Date',
                                    issue.toDate != null
                                        ? DateFormat('dd-MMM-yyyy')
                                            .format(issue.toDate!)
                                        : 'Not set',
                                    Icons.event,
                                    Colors.red),
                                _buildInfoCard(
                                    'Active',
                                    issue.isActive ?? false ? 'Yes' : 'No',
                                    Icons.check_circle,
                                    issue.isActive ?? false
                                        ? Colors.green
                                        : Colors.red),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          issue.description ?? 'No description available',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Articles',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.add, color: Colors.white),
                              label: Text('Add New Article'),
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  '${Routes.dashboard}${Routes.viewVolume}${Routes.viewIssue}${Routes.addArticle}',
                                  parameters: {
                                    'issueId': issueId,
                                    'volumeId': volumeId,
                                  },
                                );
                                if (result == true) {
                                  _loadIssueData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ResponsiveBuilder(
                          builder: (context, sizingInformation) {
                            final crossAxisCount =
                                sizingInformation.deviceScreenType ==
                                        DeviceScreenType.desktop
                                    ? 3
                                    : sizingInformation.deviceScreenType ==
                                            DeviceScreenType.tablet
                                        ? 2
                                        : 1;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: issue.articles?.length ?? 0,
                              itemBuilder: (context, index) {
                                return ArticleCard(
                                  article:
                                      issue.articles![index] as ArticleModel,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInfoCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
