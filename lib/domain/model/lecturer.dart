class Lecturer {
  final int id;
  final String firstName;
  final String lastName;
  final String middleName;
  final String photoPath;
  final String urlId;

  Lecturer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.photoPath,
    required this.urlId,
  });

  Lecturer copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? middleName,
    String? photoPath,
    String? urlId,
  }) =>
      Lecturer(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        photoPath: photoPath ?? this.photoPath,
        urlId: urlId ?? this.urlId,
      );
}
