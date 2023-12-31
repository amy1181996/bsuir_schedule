import 'package:bsuir_schedule/data/db/model/base_model.dart';

class AddLessonLecturerRelation extends BaseModel {
  final int lessonId;
  final int lecturerId;

  @override
  int get hashCode => lessonId.hashCode ^ lecturerId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddLessonLecturerRelation &&
          runtimeType == other.runtimeType &&
          lessonId == other.lessonId &&
          lecturerId == other.lecturerId;

  AddLessonLecturerRelation({
    required this.lessonId,
    required this.lecturerId,
  });

  @override
  Map<String, dynamic> toMap() => {
        'lesson_id': lessonId,
        'lecturer_id': lecturerId,
        'hash': hashCode,
      };
}

class GetLessonLecturerRelation extends BaseModel {
  @override
  // ignore: overridden_fields
  final int id;
  final int lessonId;
  final int lecturerId;

  GetLessonLecturerRelation({
    required this.id,
    required this.lessonId,
    required this.lecturerId,
  });

  factory GetLessonLecturerRelation.fromMap(Map<String, dynamic> map) =>
      GetLessonLecturerRelation(
        id: map['id'],
        lessonId: map['lesson_id'],
        lecturerId: map['lecturer_id'],
      );
}
