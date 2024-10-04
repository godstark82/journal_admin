import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';

class GetIssuesByJournalIdUseCase
    extends UseCase<DataState<List<IssueModel>>, String> {
  final IssueRepository _issueRepository;

  GetIssuesByJournalIdUseCase(this._issueRepository);

  @override
  Future<DataState<List<IssueModel>>> call(String params) async {
    return await _issueRepository.getIssuesByJournalId(params);
  }
}
