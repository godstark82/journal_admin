import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
                ElevatedButton(
                  onPressed: () async {
                    await Get.toNamed(Routes.dashboard + Routes.addIssue);
                    setState(() {});
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
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildDesktopLayout(List<IssueModel> issues, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.blue[100]),
          dataRowColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.grey[100];
              }
              return null;
            },
          ),
          columns: const [
            DataColumn(
                label: Text('Title',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Issue Number',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Volume',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Journal',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Actions',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: issues.map((issue) {
            return DataRow(cells: [
              DataCell(Text(issue.title)),
              DataCell(Text(issue.issueNumber)),
              DataCell(BlocBuilder<VolumeBloc, VolumeState>(
                builder: (context, state) {
                  if (state is VolumeLoadedAll) {
                    final volume =
                        state.volumes.firstWhere((v) => v.id == issue.volumeId);
                    return Text(volume.title);
                  }
                  return Text('Loading...');
                },
              )),
              DataCell(BlocBuilder<JournalBloc, JournalState>(
                builder: (context, state) {
                  if (state is JournalsLoaded) {
                    final journal = state.journals
                        .firstWhere((j) => j.id == issue.journalId);
                    return Text(journal.title);
                  }
                  return Text('Loading...');
                },
              )),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await editIssue(issue.id);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deleteIssue(issue.id, context);
                      setState(() {});
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
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
          child: ListTile(
            title: Text(issue.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Issue Number: ${issue.issueNumber}'),
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
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editIssue(issue.id);
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await deleteIssue(issue.id, context);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> editIssue(String issueId) async {
    Get.toNamed(Routes.dashboard + Routes.editIssue,
        parameters: {'issueId': issueId});
  }

  Future<void> deleteIssue(String issueId, BuildContext context) async {
    // Create a timer to enable the delete button after 5 seconds
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
                          // Delete the issue
                          context
                              .read<IssueBloc>()
                              .add(DeleteIssueEvent(issueId));
                          // Close the dialog
                          Get.back();
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
