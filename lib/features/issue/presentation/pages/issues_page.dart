import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<IssueBloc>().add(GetAllIssueEvent());
    context.read<VolumeBloc>().add(GetAllVolumesEvent());
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssueBloc, IssueState>(
      builder: (context, state) {
        if (state is LoadingAllIssueState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedAllIssueState) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Issues'),
              actions: [
                if (LoginConst.currentRole == Role.admin ||
                    LoginConst.currentRole == Role.author)
                  ElevatedButton(
                    onPressed: () async {
                      await Get.toNamed(Routes.dashboard + Routes.addIssue);
                      _loadData();
                    },
                    child: const Text('Add Issue'),
                  ),
              ],
            ),
            body: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return _buildDesktopLayout(state.issues, context);
                } else {
                  return _buildMobileLayout(state.issues);
                }
              },
            ),
          );
        } else if (state is ErrorIssueState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          _loadData();
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildDesktopLayout(List<IssueModel> issues, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.blue[100],
          ),
          child: Table(
            border: TableBorder.all(
              color: Colors.blue[300]!,
              width: 1,
              style: BorderStyle.solid,
            ),
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                ),
                children: [
                  _buildTableHeader('Title'),
                  _buildTableHeader('Issue Number'),
                  _buildTableHeader('Volume'),
                  _buildTableHeader('Journal'),
                  _buildTableHeader('Status'),
                  _buildTableHeader('Actions'),
                ],
              ),
              ...issues.map((issue) => TableRow(
                decoration: BoxDecoration(
                  color: issues.indexOf(issue) % 2 == 0 ? Colors.white : Colors.grey[100],
                ),
                children: [
                  _buildTableCell(Text(issue.title)),
                  _buildTableCell(Text(issue.issueNumber)),
                  _buildTableCell(
                    BlocBuilder<VolumeBloc, VolumeState>(
                      builder: (context, state) {
                        if (state is VolumeLoadedAll) {
                          final volume = state.volumes.firstWhere((v) => v.id == issue.volumeId);
                          return Text(volume.title);
                        }
                        return Text('Loading...');
                      },
                    ),
                  ),
                  _buildTableCell(
                    BlocBuilder<JournalBloc, JournalState>(
                      builder: (context, state) {
                        if (state is JournalsLoaded) {
                          final journal = state.journals.firstWhere((j) => j.id == issue.journalId);
                          return Text(journal.title);
                        }
                        return Text('Loading...');
                      },
                    ),
                  ),
                  _buildTableCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: issue.isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        issue.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  _buildTableCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (LoginConst.currentRole == Role.admin ||
                            LoginConst.currentRole == Role.author)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              await editIssue(issue.id);
                              _loadData();
                            },
                          ),
                        if (LoginConst.currentRole == Role.admin ||
                            LoginConst.currentRole == Role.author)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await deleteIssue(issue.id, context);
                              _loadData();
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell(Widget content) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: content),
      ),
    );
  }

  Widget _buildMobileLayout(List<IssueModel> issues) {
    return ListView.builder(
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blue[300]!, width: 1),
          ),
          child: ExpansionTile(
            title: Text(issue.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Issue Number: ${issue.issueNumber}'),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: issue.isActive ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                issue.isActive ? 'Active' : 'Inactive',
                style: TextStyle(color: Colors.white),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<VolumeBloc, VolumeState>(
                      builder: (context, state) {
                        if (state is VolumeLoadedAll) {
                          final volume = state.volumes.firstWhere(
                            (v) => v.id == issue.volumeId,
                          );
                          return Text('Volume: ${volume.title}');
                        }
                        return Text('Volume: Loading...');
                      },
                    ),
                    BlocBuilder<JournalBloc, JournalState>(
                      builder: (context, state) {
                        if (state is JournalsLoaded) {
                          final journal = state.journals.firstWhere(
                            (j) => j.id == issue.journalId,
                          );
                          return Text('Journal: ${journal.title}');
                        }
                        return Text('Journal: Loading...');
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (LoginConst.currentRole == Role.admin ||
                            LoginConst.currentRole == Role.author)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              await editIssue(issue.id);
                              _loadData();
                            },
                          ),
                        if (LoginConst.currentRole == Role.admin ||
                            LoginConst.currentRole == Role.author)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await deleteIssue(issue.id, context);
                              _loadData();
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> editIssue(String issueId) async {
    await Get.toNamed(Routes.dashboard + Routes.editIssue,
        parameters: {'issueId': issueId});
    _loadData();
  }

  Future<void> deleteIssue(String issueId, BuildContext context) async {
    bool isDeleteEnabled = false;
    int remainingSeconds = 5;
    Timer? deleteTimer;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            deleteTimer ??= Timer.periodic(Duration(seconds: 1), (timer) {
              setState(() {
                if (remainingSeconds > 0) {
                  remainingSeconds--;
                } else {
                  isDeleteEnabled = true;
                  timer.cancel();
                }
              });
            });
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Confirm Deletion'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Are you sure you want to delete this issue? This action cannot be undone.'),
                  SizedBox(height: 10),
                  Text(
                    '* WARNING: All articles in this issue will also be deleted.',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isDeleteEnabled
                        ? 'You can now delete the issue.'
                        : 'Please wait $remainingSeconds seconds before deleting.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    deleteTimer?.cancel();
                    Get.back();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDeleteEnabled ? Colors.red : Colors.grey,
                  ),
                  onPressed: isDeleteEnabled
                      ? () {
                          context
                              .read<IssueBloc>()
                              .add(DeleteIssueEvent(issueId));
                          Get.back();
                          _loadData();
                        }
                      : null,
                  child: Text(
                    isDeleteEnabled ? 'Delete' : 'Delete ($remainingSeconds)',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
