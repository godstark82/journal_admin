import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/pages/data/models/page_model.dart';
import 'package:journal_web/features/pages/presentation/bloc/pages_bloc.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  final pageId = Get.parameters['pageId']!;
  @override
  void initState() {
    super.initState();
    context.read<PagesBloc>().add(GetSinglePageEvent(id: pageId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: BlocBuilder<PagesBloc, PagesState>(
        builder: (context, state) {
          if (state is SinglePageLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SinglePageLoadedState) {
            return _buildPageContent(state.page);
          } else if (state is SinglePageErrorState) {
            return Center(
                child: Text('Error: ${state.error}',
                    style: TextStyle(color: Colors.red)));
          }
          return Center(
              child: Text('No data available',
                  style: TextStyle(color: Colors.grey)));
        },
      ),
    );
  }

  Widget _buildPageContent(PageModel page) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  color: Colors.blue[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          page.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.blue[800]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Last Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(page.insertDate)}',
                          style: TextStyle(color: Colors.blue[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Content:',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.blue[700]),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    // child: HtmlWidget(
                    //   page.content,
                      
                    // ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Metadata:',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.blue[700]),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('ID',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(page.id),
                        tileColor: Colors.blue[50],
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text('Created At',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
                            .format(page.insertDate)),
                        tileColor: Colors.blue[50],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
