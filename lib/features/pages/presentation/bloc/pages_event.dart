part of 'pages_bloc.dart';

abstract class PagesEvent extends Equatable {
  const PagesEvent();

  @override
  List<Object> get props => [];
}

class GetSinglePageEvent extends PagesEvent {
  final String id;

  const GetSinglePageEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdatePageEvent extends PagesEvent {
  final PageModel page;

  const UpdatePageEvent({required this.page});

  @override
  List<Object> get props => [page];
}

class DeletePageEvent extends PagesEvent {
  final String id;

  const DeletePageEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class GetAllPagesFromJournalIdEvent extends PagesEvent {
  final String journalId;
  const GetAllPagesFromJournalIdEvent(this.journalId);
}

class AddPageEvent extends PagesEvent {
  final String journalId;
  final PageModel page;

  const AddPageEvent({required this.page, required this.journalId});

  @override
  List<Object> get props => [page];
}
