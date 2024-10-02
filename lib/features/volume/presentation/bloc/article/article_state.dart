part of 'article_bloc.dart';

sealed class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

final class ArticleInitial extends ArticleState {}

class ArticlesLoading extends ArticleState {}

class ArticlesLoaded extends ArticleState {
  final List<ArticleModel> articles;

  const ArticlesLoaded({required this.articles});
}


class ArticlesError extends ArticleState {
  final String message;

  const ArticlesError({required this.message});
}
