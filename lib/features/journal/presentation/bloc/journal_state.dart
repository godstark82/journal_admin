part of 'journal_bloc.dart';

abstract class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object> get props => [];
}

class JournalInitial extends JournalState {}

class JournalsLoading extends JournalState {}

class JournalsLoaded extends JournalState {
  final List<JournalModel> journals;

  const JournalsLoaded({required this.journals});

  @override
  List<Object> get props => [journals];
}

class JournalByIdLoading extends JournalState {}

class JournalByIdLoaded extends JournalState {
  final JournalModel journal;

  const JournalByIdLoaded({required this.journal});
}

class JournalError extends JournalState {
  final String message;

  const JournalError({required this.message});
}
