part of 'pages_bloc.dart';

abstract class PagesState extends Equatable {
  const PagesState();

  @override
  List<Object> get props => [];
}

class PagesInitial extends PagesState {}

class SinglePageErrorState extends PagesState {
  final String error;

  const SinglePageErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class SinglePageLoadingState extends PagesState {}

class SinglePageLoadedState extends PagesState {
  final PageModel page;

  const SinglePageLoadedState({required this.page});

  @override
  List<Object> get props => [page];
}

class AllPagesLoadingState extends PagesState {}

class AllPagesLoadedState extends PagesState {
  final List<PageModel> pages;

  const AllPagesLoadedState({required this.pages});

  @override
  List<Object> get props => [pages];
}

class AllPagesErrorState extends PagesState {
  final String error;

  const AllPagesErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
