
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/issue_model.dart';
import 'package:journal_web/features/volume/domain/usecases/issue_usecases.dart';

part 'singleissue_event.dart';
part 'singleissue_state.dart';

class SingleissueBloc extends Bloc<SingleissueEvent, SingleissueState> {
  final GetIssueByIdUseCase getSingleIssueUseCase;
  SingleissueBloc(this.getSingleIssueUseCase) : super(SingleissueInitial()) {
    on<LoadSingleIssueEvent>(_onLoadSingleIssue);
  }

  Future<void> _onLoadSingleIssue(
      LoadSingleIssueEvent event, Emitter<SingleissueState> emit) async {
    emit(SingleIssueLoading());
    final issue = await getSingleIssueUseCase.call({
      'issueId': event.issueId,
      'volumeId': event.volumeId,
    });
    if (issue is DataSuccess) {
      emit(SingleIssueLoaded(issue: issue.data!));
    } else {
      emit(SingleIssueError(message: 'Some Error Occured'));
    }
  }
}
