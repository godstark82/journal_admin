import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/const/login_const.dart';
import 'package:journal_web/features/article/data/models/article_model.dart';
import 'package:journal_web/features/article/data/models/comment_model.dart';
import 'package:journal_web/features/article/presentation/bloc/article_bloc.dart';

class CommentsPage extends StatefulWidget {
  final ArticleModel article;

  const CommentsPage({super.key, required this.article});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: Column(children: [
          Expanded(
            child: widget.article.comments!.isEmpty
                ? Center(
                    child: Text('No Comments Yet'),
                  )
                : ListView.builder(
                    itemCount: widget.article.comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      final comment = widget.article.comments![index];
                      return Card(
                        child: ListTile(
                          title: Text(comment.content!),
                          subtitle: Text('By: ${comment.name}'),
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
                    icon: Icon(Icons.send), onPressed: () => _addComment())
              ]))
        ]));
  }

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      final newComment = CommentModel(
        content: _commentController.text,
        name: LoginConst.currentUserName,
      );

      setState(() {
        widget.article.comments ??= [];
        widget.article.comments!.add(newComment);
      });

      // Notify the ArticleBloc about the update
      context
          .read<ArticleBloc>()
          .add(ArticleUpdateEvent(article: widget.article));

      _commentController.clear();
    }
  }
}
