part of 'singlearticle_bloc.dart';

sealed class SinglearticleState extends Equatable {
  const SinglearticleState();

  @override
  List<Object> get props => [];
}

final class SinglearticleInitial extends SinglearticleState {}

class SingleArticleLoaded extends SinglearticleState {
  final ArticleModel article;

  const SingleArticleLoaded({required this.article});
}

class SingleArticleError extends SinglearticleState {
  final String message;

  const SingleArticleError({required this.message});
}

class SingleArticleLoading extends SinglearticleState {}
