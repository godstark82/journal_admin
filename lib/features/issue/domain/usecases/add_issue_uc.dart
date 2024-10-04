import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/core/usecase/usecase.dart';
import 'package:journal_web/features/issue/data/models/issue_model.dart';
import 'package:journal_web/features/issue/domain/repositories/issue_repo.dart';

class AddIssueUseCase extends UseCase<void, IssueModel> {
  final IssueRepository _issueRepository;

  AddIssueUseCase(this._issueRepository);

  @override
  Future<void> call(IssueModel params) async {
    await _issueRepository.addIssue(params);
  }
}
