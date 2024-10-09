import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/routes.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Journals'),
        actions: [
          if (LoginConst.currentUser?.role == Role.admin)
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(Routes.dashboard + Routes.addJournal);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Journal'),
            ),
        ],
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JournalsLoaded) {
            return _buildJournalList(context, state.journals);
          } else if (state is JournalError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No journals found'));
          }
        },
      ),
    );
  }

  Widget _buildJournalList(BuildContext context, List<JournalModel> journals) {
    if (journals.isEmpty) {
      return const Center(child: Text('No journals found'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _buildDesktopTable(journals);
        } else {
          return _buildMobileList(journals);
        }
      },
    );
  }

  Widget _buildDesktopTable(List<JournalModel> journals) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Theme(
          data: Theme.of(context).copyWith(
            dataTableTheme: DataTableThemeData(
              headingRowColor: WidgetStateProperty.all(Colors.blue[100]),
              dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.08);
                }
                return states.contains(WidgetState.hovered)
                    ? Colors.grey[100]
                    : null;
              }),
            ),
          ),
          child: DataTable(
            columnSpacing: 20,
            horizontalMargin: 20,
            columns: const [
              DataColumn(
                  label: Text('Title',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Creation Time',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Domain',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Actions',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: journals.map((journal) {
              return DataRow(cells: [
                DataCell(Text(journal.title,
                    style: TextStyle(color: Colors.blue[800]))),
                DataCell(Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(journal.createdAt),
                    style: TextStyle(color: Colors.green[800]))),
                DataCell(Text(journal.domain,
                    style: TextStyle(color: Colors.purple[800]))),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        await editJournal(journal.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await deleteJournal(journal.id);
                      },
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList(List<JournalModel> journals) {
    return ListView.builder(
      itemCount: journals.length,
      itemBuilder: (context, index) {
        final journal = journals[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(journal.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue[800])),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created: ${DateFormat('yyyy-MM-dd HH:mm').format(journal.createdAt)}',
                  style: TextStyle(color: Colors.green[800]),
                ),
                Text('Domain: ${journal.domain}',
                    style: TextStyle(color: Colors.purple[800])),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () async {
                    await editJournal(journal.id);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await deleteJournal(journal.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> editJournal(String journalId) async {
    await Get.toNamed(Routes.dashboard + Routes.editJournal,
        parameters: {'journalId': journalId});
    _loadData();
  }

  Future<void> deleteJournal(String journalId) async {
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
                      'Are you sure you want to delete this journal? This action cannot be undone.'),
                  SizedBox(height: 10),
                  Text(
                    '* WARNING: All volumes, issues, and articles of this journal will also be deleted.',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    isDeleteEnabled
                        ? 'You can now delete the journal.'
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
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDeleteEnabled ? Colors.red : Colors.grey,
                  ),
                  onPressed: isDeleteEnabled
                      ? () {
                          // Delete the journal
                          context
                              .read<JournalBloc>()
                              .add(DeleteJournalEvent(id: journalId));
                          // Close the dialog
                          Navigator.of(context).pop();
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
