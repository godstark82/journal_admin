import 'package:journal_web/features/journal/domain/entities/journal_entity.dart';

class JournalModel extends JournalEntity {
  const JournalModel(
      {required super.id,
      required super.title,
      required super.domain,
      required super.createdAt});

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      title: json['title'],
      domain: json['domain'],
      createdAt: DateTime.parse(json['createdAt']),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'domain': domain,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, title, domain, createdAt];

  @override
  bool? get stringify => true;

  JournalModel copyWith({
    String? id,
    String? title,
    String? domain,
    DateTime? createdAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      domain: domain ?? this.domain,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
