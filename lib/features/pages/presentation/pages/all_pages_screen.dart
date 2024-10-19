import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/pages/presentation/bloc/pages_bloc.dart';
import 'package:journal_web/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class AllPagesPage extends StatefulWidget {
  const AllPagesPage({super.key});

  @override
  _AllPagesPageState createState() => _AllPagesPageState();
}

class _AllPagesPageState extends State<AllPagesPage> {
  final journalId = Get.parameters['journalId']!;
  @override
  void initState() {
    super.initState();
    context.read<PagesBloc>().add(GetAllPagesFromJournalIdEvent(journalId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Management'),
        actions: [
          Visibility(
            visible: false,
            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.pages + Routes.addPage,
                    parameters: {'journalId': journalId});
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<PagesBloc, PagesState>(
          builder: (context, state) {
            if (state is AllPagesLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AllPagesLoadedState) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Serial No')),
                          DataColumn(label: Text('Page Name')),
                          DataColumn(label: Text('Insert Date')),
                          DataColumn(label: Text('Website')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: state.pages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final page = entry.value;
                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                return index.isOdd ? Colors.grey[100] : null;
                              },
                            ),
                            cells: [
                              DataCell(Text((index + 1).toString())),
                              DataCell(Text(page.name)),
                              DataCell(Text(DateFormat('yyyy-MM-dd')
                                  .format(page.insertDate))),
                              DataCell(Text(page.url)),
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
                                            Routes.pages + Routes.editPage,
                                            parameters: {
                                              'pageId': page.id,
                                              'journalId': journalId
                                            });
                                      },
                                      child: Text('Edit'),
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
                                                    'Are you sure you want to delete this page?'),
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
                                                          .read<PagesBloc>()
                                                          .add(DeletePageEvent(
                                                              id: page.id));
                                                      Get.back();
                                                      Get.snackbar('Success',
                                                          'Page deleted successfully');
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
                                    SizedBox(width: 8),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey,
                                        side: BorderSide(color: Colors.grey),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if ((await canLaunchUrl(
                                                Uri.parse(page.url))) ==
                                            true) {
                                          launchUrl(Uri.parse(page.url));
                                        } else {
                                          Get.snackbar('Error',
                                              'Failed to launch URL ${page.url}');
                                        }
                                      },
                                      child: Text('View'),
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
            } else if (state is AllPagesErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
