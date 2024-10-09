import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/core/const/roles.dart';
import 'package:journal_web/features/article/data/models/comment_model.dart';
import 'package:journal_web/features/login/data/models/reviewer_model.dart';
import 'package:journal_web/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';
import 'package:journal_web/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume_bloc.dart';
import 'package:journal_web/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<ArticleBloc>().add(GetAllArticleEvent());
    context.read<JournalBloc>().add(GetAllJournalEvent());
    context.read<VolumeBloc>().add(GetAllVolumesEvent());
    context.read<IssueBloc>().add(GetAllIssueEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) {
        if (state is AllArticleLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllArticleLoadedState) {
          List<ArticleModel> filteredArticles = LoginConst.currentUser?.role ==
                  Role.author
              ? state.articles
                  .where((article) => article.authors
                      .any((author) => author.id == LoginConst.currentUser?.id))
                  .toList()
              : state.articles;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Articles'),
              backgroundColor: Colors.blue,
              actions: [
                if (LoginConst.currentUser?.role == Role.admin ||
                    LoginConst.currentUser?.role == Role.author)
                  ElevatedButton(
                    onPressed: () async {
                      await Get.toNamed(Routes.dashboard + Routes.addArticle);
                      _loadData(); // Reload data after returning from add article page
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text('Add Article'),
                  ),
              ],
            ),
            body: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (filteredArticles.isEmpty) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No articles created by you yet',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Start by creating a new article'),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text('Create New Article'),
                            onPressed: () async {
                              await Get.toNamed(
                                  Routes.dashboard + Routes.addArticle);
                              _loadData();
                            },
                          )
                        ]),
                  );
                }
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return _buildDesktopLayout(filteredArticles, context);
                } else {
                  return _buildMobileLayout(filteredArticles);
                }
              },
            ),
          );
        } else if (state is ArticleErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildDesktopLayout(
      List<ArticleModel> articles, BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Table(
            columnWidths: const {
              0: FlexColumnWidth(3), // Title
              1: FlexColumnWidth(2), // Authors
              2: FlexColumnWidth(2), // Journal
              3: FlexColumnWidth(1), // Volume
              4: FlexColumnWidth(1), // Issue
              5: FlexColumnWidth(1), // Status
              6: FlexColumnWidth(2), // Publication Date
              7: FlexColumnWidth(2), // Actions
            },
            border: TableBorder.all(color: Colors.grey[300]!),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.blue[100]),
                children: [
                  _buildTableHeader('Title'),
                  _buildTableHeader('Authors'),
                  _buildTableHeader('Journal'),
                  _buildTableHeader('Volume'),
                  _buildTableHeader('Issue'),
                  _buildTableHeader('Status'),
                  _buildTableHeader('Publication Date'),
                  _buildTableHeader('Actions'),
                ],
              ),
              ...articles.map((article) => TableRow(
                    children: [
                      _buildTableCell(Text(article.title)),
                      _buildTableCell(
                          Text(article.authors.map((a) => a.name).join(', '))),
                      _buildTableCell(
                        BlocBuilder<JournalBloc, JournalState>(
                          builder: (context, state) {
                            if (state is JournalsLoaded) {
                              final journal = state.journals
                                  .firstWhere((j) => j.id == article.journalId);
                              return Text(journal.title);
                            }
                            return const Text('Loading...');
                          },
                        ),
                      ),
                      _buildTableCell(
                        BlocBuilder<VolumeBloc, VolumeState>(
                          builder: (context, state) {
                            if (state is VolumeLoadedAll) {
                              final volume = state.volumes.firstWhere(
                                (v) => v.id == article.volumeId,
                              );
                              return Text(volume.title);
                            }
                            return const Text('Loading...');
                          },
                        ),
                      ),
                      _buildTableCell(
                        BlocBuilder<IssueBloc, IssueState>(
                          builder: (context, state) {
                            if (state is LoadedAllIssueState) {
                              final issue = state.issues.firstWhere(
                                (i) => i.id == article.issueId,
                              );
                              return Text(issue.title);
                            }
                            return const Text('Loading...');
                          },
                        ),
                      ),
                      _buildTableCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(article.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article.status,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      _buildTableCell(Text(DateFormat('dd/MMMM/yyyy')
                          .format(article.createdAt))),
                      _buildTableCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility,
                                  color: Colors.purple),
                              onPressed: () {
                                viewArticleDetails(article);
                              },
                            ),
                            //* only admin and editor can EDIT this
                            if (LoginConst.currentUser?.role == Role.admin ||
                                LoginConst.currentUser?.role == Role.author)
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  await editArticle(article.id);
                                  _loadData(); // Reload data after returning from edit article page
                                },
                              ),
                            //* only admin and editor can see this
                            if (LoginConst.currentUser?.role == Role.admin ||
                                LoginConst.currentUser?.role == Role.author)
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteArticle(article.id);
                                },
                              ),
                            //* only admin and editor can see this
                            if (LoginConst.currentUser?.role == Role.admin ||
                                LoginConst.currentUser?.role == Role.reviewer)
                              IconButton(
                                icon: const Icon(Icons.comment,
                                    color: Colors.green),
                                onPressed: () {
                                  viewComments(article);
                                },
                              ),
                            //* only admin and editor can see this
                            if (LoginConst.currentUser?.role == Role.admin ||
                                LoginConst.currentUser?.role == Role.editor)
                              IconButton(
                                icon: const Icon(Icons.update,
                                    color: Colors.orange),
                                onPressed: () {
                                  updateStatus(article);
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTableCell(Widget content) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      ),
    );
  }

  Widget _buildMobileLayout(List<ArticleModel> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(article.title),
            subtitle: Text(
              '${article.authors.join(', ')}\n${DateFormat('dd/MMMM/yyyy').format(article.createdAt)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              ListTile(
                title: BlocBuilder<JournalBloc, JournalState>(
                  builder: (context, state) {
                    if (state is JournalsLoaded) {
                      final journal = state.journals.firstWhere(
                        (j) => j.id == article.journalId,
                      );
                      return Text('Journal: ${journal.title}');
                    }
                    return const Text('Journal: Loading...');
                  },
                ),
              ),
              ListTile(
                title: BlocBuilder<VolumeBloc, VolumeState>(
                  builder: (context, state) {
                    if (state is VolumeLoadedAll) {
                      final volume = state.volumes.firstWhere(
                        (v) => v.id == article.volumeId,
                      );
                      return Text('Volume: ${volume.title}');
                    }
                    return const Text('Volume: Loading...');
                  },
                ),
              ),
              ListTile(
                title: BlocBuilder<IssueBloc, IssueState>(
                  builder: (context, state) {
                    if (state is LoadedAllIssueState) {
                      final issue = state.issues.firstWhere(
                        (i) => i.id == article.issueId,
                      );
                      return Text('Issue: ${issue.title}');
                    }
                    return const Text('Issue: Loading...');
                  },
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Text('Status: '),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(article.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.purple),
                    onPressed: () {
                      viewArticleDetails(article);
                    },
                  ),
                  //* only admin and editor can see this
                  if (LoginConst.currentUser?.role == Role.admin ||
                      LoginConst.currentUser?.role == Role.author)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await editArticle(article.id);
                        _loadData(); // Reload data after returning from edit article page
                      },
                    ),
                  //* only admin and editor can see this
                  if (LoginConst.currentUser?.role == Role.admin ||
                      LoginConst.currentUser?.role == Role.author)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteArticle(article.id);
                      },
                    ),
                  //* only admin and editor can see this
                  if (LoginConst.currentUser?.role == Role.admin ||
                      LoginConst.currentUser?.role == Role.reviewer)
                    IconButton(
                      icon: const Icon(Icons.comment, color: Colors.green),
                      onPressed: () {
                        viewComments(article);
                      },
                    ),
                  //* only admin and editor can see this
                  if (LoginConst.currentUser?.role == Role.admin ||
                      LoginConst.currentUser?.role == Role.editor)
                    IconButton(
                      icon: const Icon(Icons.update, color: Colors.orange),
                      onPressed: () {
                        updateStatus(article);
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> editArticle(String id) async {
    await Get.toNamed(Routes.dashboard + Routes.editArticle,
        parameters: {'articleId': id});
  }

  void viewArticleDetails(ArticleModel article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                      Icons.person, 'Authors', article.authors.join(', ')),
                  BlocBuilder<JournalBloc, JournalState>(
                    builder: (context, state) {
                      if (state is JournalsLoaded) {
                        final journal = state.journals.firstWhere(
                          (j) => j.id == article.journalId,
                        );
                        return _buildDetailRow(
                            Icons.book, 'Journal', journal.title);
                      }
                      return _buildDetailRow(
                          Icons.book, 'Journal', 'Loading...');
                    },
                  ),
                  BlocBuilder<VolumeBloc, VolumeState>(
                    builder: (context, state) {
                      if (state is VolumeLoadedAll) {
                        final volume = state.volumes.firstWhere(
                          (v) => v.id == article.volumeId,
                        );
                        return _buildDetailRow(
                            Icons.bookmark, 'Volume', volume.title);
                      }
                      return _buildDetailRow(
                          Icons.bookmark, 'Volume', 'Loading...');
                    },
                  ),
                  BlocBuilder<IssueBloc, IssueState>(
                    builder: (context, state) {
                      if (state is LoadedAllIssueState) {
                        final issue = state.issues.firstWhere(
                          (i) => i.id == article.issueId,
                        );
                        return _buildDetailRow(
                            Icons.library_books, 'Issue', issue.title);
                      }
                      return _buildDetailRow(
                          Icons.library_books, 'Issue', 'Loading...');
                    },
                  ),
                  _buildDetailRow(Icons.calendar_today, 'Publication Date',
                      DateFormat('dd/MMMM/yyyy').format(article.createdAt)),
                  _buildDetailRow(
                    Icons.flag,
                    'Status',
                    article.status,
                    color: _getStatusColor(article.status),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Abstract:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(article.abstractString),
                  const SizedBox(height: 20),
                  Text(
                    'Comments:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...article.comments.map((comment) => ListTile(
                        title: Text(comment.msg!),
                        subtitle: Text(
                            'By: ${comment.reviewer?.name ?? 'Unknown'} on ${DateFormat('dd/MMMM/yyyy').format(comment.createdAt!)}'),
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.download, color: Colors.white),
                    label: Text('Download PDF',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(article.pdf))) {
                        await launchUrl(Uri.parse(article.pdf));
                      } else {
                        print('Could not launch ${article.pdf}');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Close',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: '$label: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value, style: TextStyle(color: color)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void viewComments(ArticleModel article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController commentController = TextEditingController();
        return AlertDialog(
          title: Text('Comments for ${article.title}',
              style: TextStyle(
                  color: Colors.blue[800], fontWeight: FontWeight.bold)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.grey[100],
          content: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...article.comments.map((comment) => Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(comment.msg!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'By: ${comment.reviewer?.name ?? 'Unknown'}\non ${DateFormat('dd/MMMM/yyyy').format(comment.createdAt!)}',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              article.comments.remove(comment);
                              context
                                  .read<ArticleBloc>()
                                  .add(EditArticleEvent(article: article));
                              Navigator.of(context).pop();
                              viewComments(article);
                            },
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        final newComment = CommentModel(
                          msg: commentController.text,
                          createdAt: DateTime.now(),
                          reviewer: ReviewerModel(
                            name: LoginConst.currentUser?.name,
                            email: LoginConst.currentUser?.email,
                            id: LoginConst.currentUser?.id,
                            role: LoginConst.currentUser?.role,
                            journalIds: LoginConst.currentUser?.journalIds,
                          ),
                        );
                        article.comments.add(newComment);
                        context
                            .read<ArticleBloc>()
                            .add(EditArticleEvent(article: article));
                        commentController.clear();
                        Navigator.of(context).pop();
                        viewComments(article);
                      }
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateStatus(ArticleModel article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newStatus = article.status;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Update Status for ${article.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current Status: ${article.status}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: newStatus,
                    isExpanded: true,
                    items: <String>['Published', 'Pending', 'Rejected']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: _getStatusColor(value),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          newStatus = value;
                        });
                      }
                    },
                    dropdownColor: Colors.grey[200],
                    elevation: 8,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: _getStatusColor(newStatus),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(newStatus),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Update the article status
                    final newArticle = article.copyWith(status: newStatus);
                    context
                        .read<ArticleBloc>()
                        .add(EditArticleEvent(article: newArticle));
                    Navigator.of(context).pop();
                    _loadData(); // Reload data after updating status
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteArticle(String articleId) async {
    // Create a timer to enable the delete button after 5 seconds
    bool isDeleteEnabled = false;
    int remainingSeconds = 5;
    Timer? deleteTimer;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            deleteTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
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
              title: const Row(
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
                  const Text(
                    'Are you sure you want to delete this article? '
                    'This action cannot be undone.',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isDeleteEnabled
                        ? 'You can now delete the article.'
                        : 'Please wait $remainingSeconds seconds before deleting.',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
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
                          // Delete the article
                          context
                              .read<ArticleBloc>()
                              .add(DeleteArticleEvent(id: articleId));
                          // Close the dialog
                          Navigator.of(context).pop();
                          _loadData(); // Reload data after deleting
                        }
                      : null,
                  child: Text(
                    isDeleteEnabled ? 'Delete' : 'Delete ($remainingSeconds)',
                    style: const TextStyle(color: Colors.white),
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
