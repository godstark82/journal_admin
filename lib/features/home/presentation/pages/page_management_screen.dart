import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/home/data/datasources/pages_data.dart';

class PageManagementPage extends StatefulWidget {
  const PageManagementPage({super.key});

  @override
  _PageManagementPageState createState() => _PageManagementPageState();
}

class _PageManagementPageState extends State<PageManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Management'),
      ),
      body: LayoutBuilder(
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
                rows: websitePages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final page = entry.value;
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        return index.isOdd ? Colors.grey[100] : null;
                      },
                    ),
                    cells: [
                      DataCell(Text(page.serialNo.toString())),
                      DataCell(Text(page.pageName)),
                      DataCell(Text(
                          DateFormat('yyyy-MM-dd').format(page.insertDate))),
                      DataCell(Text(page.website)),
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
                              
                              },
                              child: Text('Edit'),
                            ),
                            SizedBox(width: 8),
                            // OutlinedButton(
                            //   style: OutlinedButton.styleFrom(
                            //     foregroundColor: Colors.red,
                            //     side: BorderSide(color: Colors.red),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(4),
                            //     ),
                            //   ),
                            //   onPressed: () {
                            //     // TODO: Implement delete functionality
                            //   },
                            //   child: Text('Delete'),
                            // ),
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
      ),
    );
  }
}
