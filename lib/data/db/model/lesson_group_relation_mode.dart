import 'package:bsuir_schedule/data/db/model/base_model.dart';

class AddLessonGroupRelation extends BaseModel {
  final int lessonId;
  final int groupId;

  @override
  int get hashCode => lessonId.hashCode ^ groupId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddLessonGroupRelation &&
          runtimeType == other.runtimeType &&
          lessonId == other.lessonId &&
          groupId == other.groupId;

  AddLessonGroupRelation({
    required this.lessonId,
    required this.groupId,
  });

  @override
  Map<String, dynamic> toMap() => {
        'lesson_id': lessonId,
        'group_id': groupId,
        'hash': hashCode,
      };
}

class GetLessonGroupRelation extends BaseModel {
  @override
  // ignore: overridden_fields
  final int id;
  final int lessonId;
  final int groupId;

  GetLessonGroupRelation({
    required this.id,
    required this.lessonId,
    required this.groupId,
  });

  factory GetLessonGroupRelation.fromMap(Map<String, dynamic> map) =>
      GetLessonGroupRelation(
        id: map['id'],
        lessonId: map['lesson_id'],
        groupId: map['group_id'],
      );
}
