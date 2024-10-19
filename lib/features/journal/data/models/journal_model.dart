import 'package:journal_web/features/journal/domain/entities/journal_entity.dart';

class JournalModel extends JournalEntity {
  const JournalModel(
      {required super.id,
      required super.image,
      required super.title,
      required super.domain,
      required super.createdAt});

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'],
      title: json['title'],
      domain: json['domain'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'domain': domain,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, title, domain, image, createdAt];

  @override
  bool? get stringify => true;

  JournalModel copyWith({
    String? id,
    String? title,
    String? domain,
    String? image,
    DateTime? createdAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      domain: domain ?? this.domain,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
