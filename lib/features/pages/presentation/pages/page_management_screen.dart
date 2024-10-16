import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/journal/data/models/journal_model.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class PageManagementPage extends StatefulWidget {
  const PageManagementPage({super.key});

  @override
  _PageManagementPageState createState() => _PageManagementPageState();
}


class _PageManagementPageState extends State<PageManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(GetAllJournalEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('Journal Management'),
        actions: [
         
        ],
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
                                          Routes.pages + Routes.allPages,
                                          parameters: {
                                            'journalId': journal.id
                                          });
                                    },
                                    child: Text('See Pages'),
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
