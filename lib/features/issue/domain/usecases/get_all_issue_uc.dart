import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';

class GetAllIssueUC extends UseCase<DataState<List<IssueModel>>, void> {
  final IssueRepository _issueRepository;

  GetAllIssueUC(this._issueRepository);

  @override
  Future<DataState<List<IssueModel>>> call(void params) async {
    return await _issueRepository.getAllIssues();
  }
}
