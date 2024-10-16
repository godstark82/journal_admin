import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final String id;
  final String name;
  final DateTime insertDate;
  final String url;
  final String journalId;
  final String content;

  const PageModel({
    required this.id,
    required this.name,
    required this.insertDate,
    required this.url,
    required this.journalId,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'insertDate': insertDate.toIso8601String(),
        'url': url,
        'content': content,
        'journalId': journalId,
      };

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
        id: json['id'],
        name: json['name'],
        insertDate: DateTime.parse(json['insertDate']),
        url: json['url'],
        content: json['content'],
        journalId: json['journalId'] ?? '',
      );

  //copy With
  PageModel copyWith({
    String? journalId,
    String? id,
    String? name,
    DateTime? insertDate,
    String? url,
    String? content,
  }) =>
      PageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        insertDate: insertDate ?? this.insertDate,
        url: url ?? this.url,
        content: content ?? this.content,
        journalId: journalId ?? this.journalId,
      );

  @override
  List<Object?> get props => [id, name, insertDate, url, content, journalId];
}
