part of 'article_bloc.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class ArticleLoadEvent extends ArticleEvent {}

class ArticleUpdateEvent extends ArticleEvent {
  final ArticleModel article;

  const ArticleUpdateEvent({required this.article});
}

class ArticleDeleteEvent extends ArticleEvent {
  final String id;

  const ArticleDeleteEvent({required this.id});
}

class ArticleAddEvent extends ArticleEvent {
  final ArticleModel article;

  const ArticleAddEvent({required this.article});
}
