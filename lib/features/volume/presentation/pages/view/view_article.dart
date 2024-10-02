import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/article/singlearticle/singlearticle_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ViewArticlePage extends StatefulWidget {
  const ViewArticlePage({super.key});

  @override
  _ViewArticlePageState createState() => _ViewArticlePageState();
}

class _ViewArticlePageState extends State<ViewArticlePage> {
  late String articleId;
  late String issueId;
  late String volumeId;

  @override
  void initState() {
    super.initState();
    articleId = Get.parameters['articleId'] ?? '';
    issueId = Get.parameters['issueId'] ?? '';
    volumeId = Get.parameters['volumeId'] ?? '';
    _loadArticleData();
  }

  void _loadArticleData() {
    if (articleId.isNotEmpty && issueId.isNotEmpty && volumeId.isNotEmpty) {
      context.read<SinglearticleBloc>().add(LoadSingleArticleEvent(
            articleId: articleId,
            issueId: issueId,
            volumeId: volumeId,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Article'),
        backgroundColor: Colors.indigo[700],
      ),
      body: BlocBuilder<SinglearticleBloc, SinglearticleState>(
        builder: (context, state) {
          if (state is SingleArticleLoaded) {
            ArticleModel article = state.article;
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                return Center(
                  child: Container(
                    width: sizingInformation.deviceScreenType ==
                            DeviceScreenType.desktop
                        ? 800
                        : double.infinity,
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4,
                            color: Colors.amber[100],
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[800],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  _buildDetailRow(
                                      Icons.description,
                                      'Document Type',
                                      article.documentType ?? 'Not specified',
                                      Colors.orange[700]!),
                                  _buildDetailRow(
                                      Icons.category,
                                      'Main Subject',
                                      article.mainSubjects?.join(',') ??
                                          'Not specified',
                                      Colors.green[700]!),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildDetailRow(
                              Icons.person,
                              'Author',
                              article.authors?.join(', ') ?? 'Unknown',
                              Colors.purple[700]!),
                          _buildDetailRow(
                              Icons.calendar_today,
                              'Publication Date',
                              article.createdAt != null
                                  ? DateFormat('dd-MMMM-yyyy')
                                      .format(article.createdAt!)
                                  : 'Not set',
                              Colors.blue[700]!),
                          _buildDetailRow(
                              Icons.short_text,
                              'Abstract',
                              article.abstractString ?? 'No abstract available',
                              Colors.teal[700]!),
                          SizedBox(height: 16),
                          Text(
                            'Keywords:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[600],
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            children: (article.keywords ?? [])
                                .map((keyword) => Chip(
                                      label: Text(keyword),
                                      backgroundColor: Colors.indigo[100],
                                      labelStyle:
                                          TextStyle(color: Colors.indigo[700]),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: Icon(Icons.picture_as_pdf),
                            label: Text('View Full Article'),
                            onPressed: () {
                              // Implement PDF viewer or download functionality
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Comments:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          article.comments?.isEmpty ?? true
                              ? Text('No comments yet.',
                                  style: TextStyle(fontStyle: FontStyle.italic))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: article.comments?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final comment = article.comments![index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      color: Colors.grey[100],
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.person,
                                                    color: Colors.indigo[400]),
                                                SizedBox(width: 8),
                                                Text(
                                                  comment.name ?? 'Anonymous',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.indigo[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text(comment.content ?? ''),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
