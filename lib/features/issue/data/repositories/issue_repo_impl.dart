import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';
import 'package:journal_web/services/issue_services.dart';

class IssueRepoImpl implements IssueRepository {
  final IssueServices _issueServices;

  IssueRepoImpl(this._issueServices);

  @override
  Future<void> addIssue(IssueModel issue) async {
    await _issueServices.addIssue(issue);
  }
  
  @override
  Future<void> deleteIssue(String id) async {
    await _issueServices.deleteIssue(id);
  }
  
  @override
  Future<DataState<List<IssueModel>>> getAllIssues() {
    return _issueServices.getAllIssues();
  }
  
  @override
  Future<DataState<IssueModel>> getIssueById(String id) {
    return _issueServices.getIssueById(id);
  }
  
  @override
  Future<DataState<List<IssueModel>>> getIssuesByJournalId(String journalId) {
    return _issueServices.getIssuesByJournalId(journalId);
  }
  
  @override
  Future<DataState<List<IssueModel>>> getIssuesByVolumeId(String volumeId) {
    return _issueServices.getIssuesByVolumeId(volumeId);
  }
  
  @override
  Future<void> updateIssue(IssueModel issue) async {
    await _issueServices.updateIssue(issue);
  }
}
