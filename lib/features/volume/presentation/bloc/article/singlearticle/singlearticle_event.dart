part of 'singlearticle_bloc.dart';

sealed class SinglearticleEvent extends Equatable {
  const SinglearticleEvent();

  @override
  List<Object> get props => [];
}

class LoadSingleArticleEvent extends SinglearticleEvent {
  final String articleId;
  final String issueId;
  final String volumeId;

  const LoadSingleArticleEvent({
    required this.articleId,
    required this.issueId,
    required this.volumeId,
  });
}
