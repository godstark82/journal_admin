import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/article_model.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';

class VolumeServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Volume operations
  Future<void> createVolume(VolumeModel volume) async {
    final docRef = _firestore.collection('volumes').doc();
    volume.id = docRef.id;
    volume.createdAt = DateTime.now();
    await docRef.set(volume.toJson());
  }

  Future<List<IssueModel>> getIssuesForVolume(String volumeId) async {
    final snapshot = await _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .get();
    log('Retrieved ${snapshot.docs.length} issues');
    return snapshot.docs.map((doc) => IssueModel.fromJson(doc.data())).toList();
  }

  Future<DataState<VolumeModel>> getVolume(String volumeId) async {
    try {
      final snapshot =
          await _firestore.collection('volumes').doc(volumeId).get();
      final issues = await getIssuesForVolume(volumeId);
      final volume =
          VolumeModel.fromJson(snapshot.data() as Map<String, dynamic>);
      volume.issues = issues;
      return DataSuccess(volume);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<List<VolumeModel>>> getAllVolume() async {
    // try {
    final snapshot = await _firestore.collection('volumes').get();
    return DataSuccess(
        snapshot.docs.map((doc) => VolumeModel.fromJson(doc.data())).toList());
    // } catch (e) {
    // return DataFailed(e.toString());
    // }
  }

  Future<void> updateVolume(VolumeModel volume) async {
    await _firestore
        .collection('volumes')
        .doc(volume.id)
        .update(volume.toJson());
  }

  Future<void> deleteVolume(String volumeId) async {
    await _firestore.collection('volumes').doc(volumeId).delete();
  }

  // Issue operations
  Future<void> createIssue(String volumeId, IssueModel issue) async {
    final docRef = _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .doc();
    issue.id = docRef.id;
    issue.volumeId = volumeId;
    await docRef.set(issue.toJson());
  }

  Future<DataState<IssueModel>> getSingleIssue(
      {required String volumeId, required String issueId}) async {
    try {
      log('Fetching issue $issueId for volume $volumeId');
      final snapshot = await _firestore
          .collection('volumes')
          .doc(volumeId)
          .collection('issues')
          .doc(issueId)
          .get();

      IssueModel? issue =
          IssueModel.fromJson(snapshot.data() as Map<String, dynamic>);

      final articles = await getArticlesForIssue(issueId, volumeId);

      issue.articles = articles;
      return DataSuccess(issue);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<List<ArticleModel>> getArticlesForIssue(
      String issueId, String volumeId) async {
    final articlesSnapshot = await _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .doc(issueId)
        .collection('articles')
        .get();

    return articlesSnapshot.docs
        .map((doc) => ArticleModel.fromJson(doc.data()))
        .toList();
  }

  Future<DataState<List<IssueModel>>> getAllIssue(String volumeId) async {
    // try {
    log('Fetching issues for volume $volumeId');
    final snapshot = await _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .get();

    log('Retrieved ${snapshot.docs.length} issues');

    if (snapshot.docs.isEmpty) {
      return DataSuccess([]);
    }
    return DataSuccess(
        snapshot.docs.map((doc) => IssueModel.fromJson(doc.data())).toList());
  }

  Future<void> updateIssue(IssueModel issue) async {
    try {
      log('Updating issue ${issue.id} for volume ${issue.volumeId}');
      await _firestore
          .collection('volumes')
          .doc(issue.volumeId)
          .collection('issues')
          .doc(issue.id)
          .update(issue.toJson());
      log('Issue updated successfully');
    } catch (e) {
      log('Error updating issue: $e');
    }
  }

  Future<void> deleteIssue(String volumeId, String issueId) async {
    await _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .doc(issueId)
        .delete();
  }

  // Article operations
  Future<void> createArticle(
      String volumeId, String issueId, ArticleModel article) async {
    final docRef = _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .doc(issueId)
        .collection('articles')
        .doc();
    article = article.copyWith(id: docRef.id);
    await docRef.set(article.toJson());
  }

  Future<DataState<ArticleModel>> getArticle(
      {required String articleId,
      required String issueId,
      required String volumeId}) async {
    try {
      final snapshot = await _firestore
          .collection('volumes')
          .doc(volumeId)
          .collection('issues')
          .doc(issueId)
          .collection('articles')
          .doc(articleId)
          .get();
      return DataSuccess(
          ArticleModel.fromJson(snapshot.data() as Map<String, dynamic>));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<List<ArticleModel>>> getAllArticleOfIssue(
      String issueId, String volumeId) async {
    try {
      final snapshot = await _firestore
          .collection('volumes')
          .doc(volumeId)
          .collection('issues')
          .doc(issueId)
          .collection('articles')
          .get();
      return DataSuccess(snapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<void> updateArticle(
      String volumeId, String issueId, ArticleModel article) async {
    await _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .doc(issueId)
        .collection('articles')
        .doc(article.id)
        .update(article.toJson());
  }

  Future<void> deleteArticle(
      String volumeId, String issueId, String articleId) async {
    await _firestore
        .collection('volumes')
        .doc(volumeId)
        .collection('issues')
        .doc(issueId)
        .collection('articles')
        .doc(articleId)
        .delete();
  }
}
