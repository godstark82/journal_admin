import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';

class IssueServices {
  final issueCollection = FirebaseFirestore.instance.collection('issues');

  Future<void> addIssue(IssueModel issue) async {
    final docRef = issueCollection.doc();
    issue = issue.copyWith(id: docRef.id);
    await docRef.set(issue.toJson());

    if (issue.isActive) {
      // Get all issues under the same journal and volume
      final querySnapshot = await issueCollection
          .where('journalId', isEqualTo: issue.journalId)
          .where('volumeId', isEqualTo: issue.volumeId)
          .get();

      // Update all other issues to be inactive
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        if (doc.id != issue.id) {
          batch.update(doc.reference, {'isActive': false});
        }
      }

      // Commit the batch update
      await batch.commit();
    }
  }

  Future<void> deleteIssue(String id) async {
    await issueCollection.doc(id).delete();
  }

  Future<void> updateIssue(IssueModel issue) async {
    await issueCollection.doc(issue.id).update(issue.toJson());

    if (issue.isActive) {
      // Get all issues under the same journal and volume
      final querySnapshot = await issueCollection
          .where('journalId', isEqualTo: issue.journalId)
          .where('volumeId', isEqualTo: issue.volumeId)
          .get();

      // Update all other issues to be inactive
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        if (doc.id != issue.id) {
          batch.update(doc.reference, {'isActive': false});
        }
      }

      // Commit the batch update
      await batch.commit();
    }
  }

  Future<DataState<List<IssueModel>>> getAllIssues() async {
    try {
      final snapshot = await issueCollection.get();
      return DataSuccess(
          snapshot.docs.map((doc) => IssueModel.fromJson(doc.data())).toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<List<IssueModel>>> getIssuesByJournalId(
      String journalId) async {
    try {
      final snapshot =
          await issueCollection.where('journalId', isEqualTo: journalId).get();
      return DataSuccess(
          snapshot.docs.map((doc) => IssueModel.fromJson(doc.data())).toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<List<IssueModel>>> getIssuesByVolumeId(
      String volumeId) async {
    try {
      final snapshot =
          await issueCollection.where('volumeId', isEqualTo: volumeId).get();
      return DataSuccess(
          snapshot.docs.map((doc) => IssueModel.fromJson(doc.data())).toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<IssueModel>> getIssueById(String id) async {
    try {
      final snapshot = await issueCollection.doc(id).get();
      return DataSuccess(IssueModel.fromJson(snapshot.data()!));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
