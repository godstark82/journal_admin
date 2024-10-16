import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class EBHome extends StatefulWidget {
  const EBHome({super.key});

  @override
  _EBHomeState createState() => _EBHomeState();
}

class _EBHomeState extends State<EBHome> {
  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Editoial Board Management'),
        actions: [],
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is JournalsLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Serial No')),
                        DataColumn(label: Text('Journal Name')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: state.journals.asMap().entries.map((entry) {
                        final index = entry.key;
                        final journal = entry.value;
                        return DataRow(
                          color: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              return index.isOdd ? Colors.grey[100] : null;
                            },
                          ),
                          cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(Text(journal.title)),
                            DataCell(Text(journal.domain)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green,
                                      side: BorderSide(color: Colors.green),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Edit functionality
                                      Get.toNamed(
                                          Routes.dashboard +
                                              Routes.editorialBoard,
                                          parameters: {
                                            'journalId': journal.id
                                          });
                                    },
                                    child: Text('View'),
                                  ),
                                  SizedBox(width: 8),
                                  Visibility(
                                    visible: false,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirm Delete'),
                                              content: Text(
                                                  'Are you sure you want to delete this journal?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Delete'),
                                                  onPressed: () {
                                                    context
                                                        .read<JournalBloc>()
                                                        .add(DeleteJournalEvent(
                                                            id: journal.id));
                                                    Get.back();
                                                    Get.snackbar('Success',
                                                        'Journal deleted successfully');
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          } else if (state is JournalError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
