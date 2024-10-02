part of 'article_bloc.dart';

sealed class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}



class AddArticleEvent extends ArticleEvent {
  final ArticleModel article;
  final String volumeId;
  final String issueId;

  const AddArticleEvent(
      {required this.article, required this.volumeId, required this.issueId});
}

class DeleteArticleEvent extends ArticleEvent {
  final String volumeId;
  final String issueId;
  final String articleId;

  const DeleteArticleEvent(
      {required this.volumeId, required this.issueId, required this.articleId});
}

class UpdateArticleEvent extends ArticleEvent {
  final ArticleModel article;
  final String volumeId;
  final String issueId;

  const UpdateArticleEvent(
      {required this.article, required this.volumeId, required this.issueId});
}
