import 'package:bsuir_schedule/domain/model/group.dart';

class ApiGroup {
  final String name;
  final String facultyAbbrev;
  final String specialityName;
  final String specialityAbbrev;
  final int course;

  ApiGroup({
    required this.name,
    required this.facultyAbbrev,
    required this.specialityName,
    required this.specialityAbbrev,
    required this.course,
  });

  factory ApiGroup.fromJson(Map<String, dynamic> json) => ApiGroup(
        name: json['name'],
        facultyAbbrev: json['facultyAbbrev'],
        specialityName: json['specialityName'],
        specialityAbbrev: json['specialityAbbrev'],
        course: json['course'],
      );

  Group toGroup() => Group(
        id: 0,
        name: name,
        facultyAbbrev: facultyAbbrev,
        specialityName: specialityName,
        specialityAbbrev: specialityAbbrev,
        course: course,
      );
}
