import 'package:bsuir_schedule/data/db/model/base_model.dart';

class AddLessonGroupRelation extends BaseModel {
  final int lessonId;
  final int groupId;

  AddLessonGroupRelation({
    required this.lessonId,
    required this.groupId,
  });

  @override
  Map<String, dynamic> toMap() => {
        'lesson_id': lessonId,
        'group_id': groupId,
      };
}

class GetLessonGroupRelation extends BaseModel {
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
