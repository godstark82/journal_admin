part of 'article_bloc.dart';

abstract class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleDeleteArticleState extends ArticleState {
  final ArticleModel article;
  const ArticleDeleteArticleState(this.article);
}

class ArticleUpdateArticleState extends ArticleState {
  final ArticleModel article;
  const ArticleUpdateArticleState(this.article);
}

class ArticleAddNewArticleState extends ArticleState {
  final ArticleModel article;
  const ArticleAddNewArticleState(this.article);
}

class ArticleLoaded extends ArticleState {
  final List<ArticleModel> articles;
  const ArticleLoaded(this.articles);
}

class ArticleError extends ArticleState {
  final String message;
  const ArticleError(this.message);
}
