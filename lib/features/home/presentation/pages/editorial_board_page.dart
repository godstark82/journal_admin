import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/routes.dart';
import 'package:journal_web/services/admin_services.dart';

class EditorialBoardPage extends StatefulWidget {
  const EditorialBoardPage({super.key});

  @override
  State<EditorialBoardPage> createState() => _EditorialBoardPageState();
}

class _EditorialBoardPageState extends State<EditorialBoardPage> {
  @override
  Widget build(BuildContext context) {
    final adminServices = AdminServices();
    final String journalId = Get.parameters['journalId']!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Editorial Board'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              onPressed: () async {
                await Get.toNamed(
                    Routes.editorialBoard + Routes.addEditorialBoard,
                    parameters: {
                      'journalId': journalId,
                    });
                setState(() {});
              },
              icon: Icon(Icons.add),
              label: Text('Add EditorialBoard'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: adminServices.getEditorialBoardMembers().then((members) =>
              members
                  .where((member) => member.journalId == journalId)
                  .toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: context.width,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Created At')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List<DataRow>.generate(
                              snapshot.data!.length,
                              (index) => DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return index % 2 == 0
                                        ? Colors.grey[200]
                                        : null;
                                  },
                                ),
                                cells: [
                                  DataCell(Text(snapshot.data![index].name)),
                                  DataCell(Text(snapshot.data![index].email)),
                                  DataCell(Text(snapshot.data![index].role)),
                                  DataCell(Text(DateFormat('dd-MMMM-yyyy')
                                      .format(
                                          snapshot.data![index].createdAt))),
                                  DataCell(Row(
                                    children: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          await Get.toNamed(
                                            Routes.editorialBoard +
                                                Routes.editEditorialBoard,
                                            parameters: {
                                              'journalId': snapshot
                                                  .data![index].journalId,
                                              'memberId':
                                                  snapshot.data![index].id
                                            },
                                          );
                                          setState(() {});
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.green,
                                          side: BorderSide(color: Colors.green),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                        child: Text('Edit'),
                                      ),
                                      SizedBox(width: 8),
                                      OutlinedButton(
                                        onPressed: () async {
                                          final adminServices = AdminServices();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Deletion'),
                                                content: Text(
                                                    'Are you sure you want to delete this editorial board member?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () async {
                                                      await adminServices
                                                          .deleteEditorialBoardMember(
                                                              snapshot
                                                                  .data![index]
                                                                  .id);
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: BorderSide(color: Colors.red),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
