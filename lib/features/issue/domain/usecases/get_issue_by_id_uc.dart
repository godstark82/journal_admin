import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';

class GetIssueByIdUseCase extends UseCase<DataState<IssueModel>, String> {
  final IssueRepository _issueRepository;

  GetIssueByIdUseCase(this._issueRepository);

  @override
  Future<DataState<IssueModel>> call(String params) async {
    return await _issueRepository.getIssueById(params);
  }
}
