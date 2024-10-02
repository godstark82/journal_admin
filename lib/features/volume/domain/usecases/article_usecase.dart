import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';

import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';

class GetArticleByIdUseCase
    extends UseCase<DataState<ArticleModel>, Map<String, dynamic>> {
  final VolumeRepo repository;

  GetArticleByIdUseCase(this.repository);

  @override
  Future<DataState<ArticleModel>> call(Map<String, dynamic> params) async {
    return await repository.getArticle(
        articleId: params['articleId'],
        issueId: params['issueId'],
        volumeId: params['volumeId']);
  }
}

class UpdateArticleUseCase extends UseCase<void, Map<String, dynamic>> {
  final VolumeRepo repository;

  UpdateArticleUseCase(this.repository);

  @override
  Future<void> call(Map<String, dynamic> params) async {
    return await repository.updateArticle(
        params['article'], params['issueId'], params['volumeId']);
  }
}

class DeleteArticleUseCase extends UseCase<void, Map<String, dynamic>> {
  final VolumeRepo repository;

  DeleteArticleUseCase(this.repository);

  @override
  Future<void> call(Map<String, dynamic> params) async {
    return await repository.deleteArticle(
        params['articleId'], params['issueId'], params['volumeId']);
  }
}

class CreateArticleUseCase extends UseCase<void, Map<String, dynamic>> {
  final VolumeRepo repository;

  CreateArticleUseCase(this.repository);

  @override
  Future<void> call(Map<String, dynamic> params) async {
    return await repository.createArticle(
        params['article'], params['issueId'], params['volumeId']);
  }
}

class GetArticlesByIssueIdUseCase
    extends UseCase<DataState<List<ArticleModel>>, Map<String, dynamic>> {
  final VolumeRepo repository;

  GetArticlesByIssueIdUseCase(this.repository);

  @override
  Future<DataState<List<ArticleModel>>> call(
      Map<String, dynamic> params) async {
    return await repository.getAllArticleOfIssue(
      issueId: params['issueId'],
      volumeId: params['volumeId'],
    );
  }
}
