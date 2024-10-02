import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final int serialNo;
  final String pageName;
  final DateTime insertDate;
  final String website;

  const PageModel({
    required this.serialNo,
    required this.pageName,
    required this.insertDate,
    required this.website,
  });

  @override
  List<Object?> get props => [serialNo, pageName, insertDate, website];
}


