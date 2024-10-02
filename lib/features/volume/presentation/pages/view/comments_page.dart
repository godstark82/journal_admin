import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';
import 'package:journal_web/features/volume/data/models/comment_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/article/article_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/article/singlearticle/singlearticle_bloc.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final String issueId = Get.parameters['issueId']!;
  final String volumeId = Get.parameters['volumeId']!;
  final String articleId = Get.parameters['articleId']!;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: BlocBuilder<SinglearticleBloc, SinglearticleState>(
          builder: (context, state) {
            if (state is SingleArticleLoaded) {
              ArticleModel article = state.article;
              return Column(children: [
                Expanded(
                  child: article.comments?.isEmpty ?? true
                      ? Center(
                          child: Text('No Comments Yet'),
                        )
                      : ListView.builder(
                          itemCount: article.comments?.length ?? 0,
                          itemBuilder: (context, index) {
                            final comment = article.comments![index];
                            return Card(
                              child: ListTile(
                                title: Text(comment.content!),
                                subtitle: Text('By: ${comment.name}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteComment(article, index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async =>
                              article = await _addComment(article))
                    ]))
              ]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Future<ArticleModel> _addComment(ArticleModel article) async {
    if (_commentController.text.isNotEmpty) {
      final newComment = CommentModel(
        content: _commentController.text,
        name: LoginConst.currentUserName,
      );

      setState(() {
        article.comments ??= [];
        article.comments!.add(newComment);
      });

      // Notify the ArticleBloc about the update
      context.read<ArticleBloc>().add(UpdateArticleEvent(
          article: article, issueId: issueId, volumeId: volumeId));

      _commentController.clear();
    }
    return article;
  }

  void _deleteComment(ArticleModel article, int index) {
    setState(() {
      article.comments!.removeAt(index);
    });

    // Notify the ArticleBloc about the update
    context.read<ArticleBloc>().add(UpdateArticleEvent(
        article: article, issueId: issueId, volumeId: volumeId));
  }
}
