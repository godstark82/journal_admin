import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final String id;
  final String name;
  final DateTime insertDate;
  final String website;
  final String content;

  const PageModel({
    required this.id,
    required this.name,
    required this.insertDate,
    required this.website,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'insertDate': insertDate.toIso8601String(),
        'website': website,
        'content': content,
      };

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
        id: json['id'],
        name: json['name'],
        insertDate: DateTime.parse(json['insertDate']),
        website: json['website'],
        content: json['content'],
      );

  //copy With
  PageModel copyWith({
    String? id,
    String? name,
    DateTime? insertDate,
    String? website,
    String? content,
  }) =>
      PageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        insertDate: insertDate ?? this.insertDate,
        website: website ?? this.website,
        content: content ?? this.content,
      );

  @override
  List<Object?> get props => [id, name, insertDate, website, content];
}
