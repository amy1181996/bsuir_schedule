import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';

class AddLecturer extends BaseModel {
  final String firstName;
  final String lastName;
  final String middleName;
  final String photoPath;
  final String urlId;

  AddLecturer(
    int id, {
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.photoPath,
    required this.urlId,
  });

  factory AddLecturer.fromLecturer(Lecturer lecturer) => AddLecturer(
        lecturer.id,
        firstName: lecturer.firstName,
        lastName: lecturer.lastName,
        middleName: lecturer.middleName,
        photoPath: lecturer.photoPath,
        urlId: lecturer.urlId,
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'photo_path': photoPath,
      'url_id': urlId,
    };
  }
}

class GetLecturer extends BaseModel {
  final int id;
  final String firstName;
  final String lastName;
  final String middleName;
  final String photoPath;
  final String urlId;

  GetLecturer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.photoPath,
    required this.urlId,
  });

  factory GetLecturer.fromMap(Map<String, dynamic> map) => GetLecturer(
        id: map['id'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        middleName: map['middle_name'],
        photoPath: map['photo_path'],
        urlId: map['url_id'],
      );

  Lecturer toLecturer() => Lecturer(
        id: id,
        firstName: firstName,
        lastName: lastName,
        middleName: middleName,
        photoPath: photoPath,
        urlId: urlId,
      );
}
