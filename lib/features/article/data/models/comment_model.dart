import 'package:journal_web/features/login/data/models/reviewer_model.dart';

class CommentModel {
  ReviewerModel? reviewer;
  String? msg;
  DateTime? createdAt;

  CommentModel({this.reviewer, this.msg, this.createdAt});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      reviewer: ReviewerModel.fromJson(json['reviewer']),
      msg: json['msg'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewer': reviewer?.toJson(),
      'msg': msg,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
