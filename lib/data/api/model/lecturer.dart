import 'package:bsuir_schedule/domain/model/lecturer.dart';

class ApiLecturer {
  final String firstName;
  final String lastName;
  final String middleName;
  final String photoLink;
  final String urlId;

  ApiLecturer({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.photoLink,
    required this.urlId,
  });

  factory ApiLecturer.fromJson(Map<String, dynamic> json) => ApiLecturer(
        firstName: json['firstName'],
        lastName: json['lastName'],
        middleName: json['middleName'],
        photoLink: json['photoLink'],
        urlId: json['urlId'],
      );

  Lecturer toLecturer() => Lecturer(
        id: 0,
        firstName: firstName,
        lastName: lastName,
        middleName: middleName,
        photoPath: photoLink.split('/').last,
        urlId: urlId,
      );
}
