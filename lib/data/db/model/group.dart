import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:bsuir_schedule/domain/model/group.dart';

class AddGroup extends BaseModel {
  final String name;
  final String facultyAbbrev;
  final String specialityName;
  final String specialityAbbrev;
  final int course;

  AddGroup(
    int id, {
    required this.name,
    required this.facultyAbbrev,
    required this.specialityName,
    required this.specialityAbbrev,
    required this.course,
  }) {
    this.id = id;
  }

  factory AddGroup.fromGroup(Group group) => AddGroup(
        group.id,
        name: group.name,
        facultyAbbrev: group.facultyAbbrev,
        specialityName: group.specialityName,
        specialityAbbrev: group.specialityAbbrev,
        course: group.course,
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'faculty_abbrev': facultyAbbrev,
      'speciality_name': specialityName,
      'speciality_abbrev': specialityAbbrev,
      'course': course,
    };
  }
}

class GetGroup extends BaseModel {
  @override
  // ignore: overridden_fields
  final int id;
  final String name;
  final String facultyAbbrev;
  final String specialityName;
  final String specialityAbbrev;
  final int course;

  GetGroup({
    required this.id,
    required this.name,
    required this.facultyAbbrev,
    required this.specialityName,
    required this.specialityAbbrev,
    required this.course,
  });

  factory GetGroup.fromMap(Map<String, dynamic> map) => GetGroup(
        id: map['id'],
        name: map['name'],
        facultyAbbrev: map['faculty_abbrev'],
        specialityName: map['speciality_name'],
        specialityAbbrev: map['speciality_abbrev'],
        course: map['course'],
      );

  Group toGroup() => Group(
        id: id,
        name: name,
        facultyAbbrev: facultyAbbrev,
        specialityName: specialityName,
        specialityAbbrev: specialityAbbrev,
        course: course,
      );
}
