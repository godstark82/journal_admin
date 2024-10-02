import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';

import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';

abstract class VolumeRepo {
  //! Volume
  Future<DataState<VolumeModel>> getVolume(String volumeId);
  Future<DataState<List<VolumeModel>>> getAllVolume();
  Future<void> createVolume(VolumeModel volume);
  Future<void> updateVolume(VolumeModel volume);
  Future<void> deleteVolume(String volumeId);

  //! Issue
  Future<DataState<IssueModel>> getIssue(
      {required String volumeId, required String issueId});
  Future<DataState<List<IssueModel>>> getAllIssue(String volumeId);
  Future<void> createIssue(IssueModel issue, String volumeId);
  Future<void> updateIssue(IssueModel issue);
  Future<void> deleteIssue(String issueId, String volumeId);

  //! Article
  Future<DataState<ArticleModel>> getArticle(
      {required String articleId,
      required String issueId,
      required String volumeId});
  Future<DataState<List<ArticleModel>>> getAllArticleOfIssue(
      {required String issueId, required String volumeId});
  Future<void> createArticle(
      ArticleModel article, String issueId, String volumeId);
  Future<void> updateArticle(
      ArticleModel article, String issueId, String volumeId);
  Future<void> deleteArticle(String articleId, String issueId, String volumeId);
}
