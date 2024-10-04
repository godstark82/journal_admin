import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';

abstract class IssueRepository {
  Future<DataState<List<IssueModel>>> getAllIssues();
  Future<DataState<List<IssueModel>>> getIssuesByJournalId(String journalId);
  Future<DataState<List<IssueModel>>> getIssuesByVolumeId(String volumeId);
  Future<DataState<IssueModel>> getIssueById(String id);
  Future<void> addIssue(IssueModel issue);
  Future<void> deleteIssue(String id);
  Future<void> updateIssue(IssueModel issue);
}
