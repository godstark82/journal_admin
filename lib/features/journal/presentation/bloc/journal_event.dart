part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

class GetAllJournalEvent extends JournalEvent {}

class GetJournalByIdEvent extends JournalEvent {
  final String id;

  const GetJournalByIdEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class DeleteJournalEvent extends JournalEvent {
  final String id;

  const DeleteJournalEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class CreateJournalEvent extends JournalEvent {
  final JournalModel journal;

  const CreateJournalEvent({required this.journal});

  @override
  List<Object> get props => [journal];
}

class UpdateJournalEvent extends JournalEvent {
  final JournalModel journal;

  const UpdateJournalEvent({required this.journal});

  @override
  List<Object> get props => [journal];
}
