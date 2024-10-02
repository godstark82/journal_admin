import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';

import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/repositories/volume_repo.dart';
import 'package:journal_web/services/volume_services.dart';

class VolumeRepoImpl implements VolumeRepo {
  final VolumeServices _volumeServices;

  VolumeRepoImpl(this._volumeServices);

  @override
  Future<void> createArticle(
      ArticleModel article, String issueId, String volumeId) async {
    return await _volumeServices.createArticle(volumeId, issueId, article);
  }

  @override
  Future<void> createIssue(IssueModel issue, String volumeId) async {
    return await _volumeServices.createIssue(volumeId, issue);
  }

  @override
  Future<void> createVolume(VolumeModel volume) async {
    return await _volumeServices.createVolume(volume);
  }

  @override
  Future<void> deleteArticle(
      String articleId, String issueId, String volumeId) async {
    return await _volumeServices.deleteArticle(volumeId, issueId, articleId);
  }

  @override
  Future<void> deleteIssue(String issueId, String volumeId) async {
    return await _volumeServices.deleteIssue(volumeId, issueId);
  }

  @override
  Future<void> deleteVolume(String volumeId) async {
    return await _volumeServices.deleteVolume(volumeId);
  }

  @override
  Future<DataState<List<ArticleModel>>> getAllArticleOfIssue(
      {required String issueId, required String volumeId}) async {
    return await _volumeServices.getAllArticleOfIssue(volumeId, issueId);
  }

  @override
  Future<DataState<List<IssueModel>>> getAllIssue(String volumeId) async {
    return await _volumeServices.getAllIssue(volumeId);
  }

  @override
  Future<DataState<List<VolumeModel>>> getAllVolume() async {
    return await _volumeServices.getAllVolume();
  }

  @override
  Future<DataState<ArticleModel>> getArticle(
      {required String articleId,
      required String issueId,
      required String volumeId}) async {
    return await _volumeServices.getArticle(
        volumeId: volumeId, issueId: issueId, articleId: articleId);
  }

  @override
  Future<DataState<IssueModel>> getIssue(
      {required String volumeId, required String issueId}) async {
    return await _volumeServices.getSingleIssue(
        volumeId: volumeId, issueId: issueId);
  }

  @override
  Future<DataState<VolumeModel>> getVolume(String volumeId) async {
    return await _volumeServices.getVolume(volumeId);
  }

  @override
  Future<void> updateArticle(
      ArticleModel article, String issueId, String volumeId) async {
    return await _volumeServices.updateArticle(volumeId, issueId, article);
  }

  @override
  Future<void> updateIssue(
       IssueModel issue) async {
    return await _volumeServices.updateIssue(issue);
  }

  @override
  Future<void> updateVolume(VolumeModel volume) async {
    return await _volumeServices.updateVolume(volume);
  }
}
