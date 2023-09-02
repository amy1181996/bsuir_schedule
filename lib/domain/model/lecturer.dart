class Lecturer {
  final int id;
  final String firstName;
  final String lastName;
  final String middleName;
  final String photoPath;
  final String urlId;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      middleName.hashCode ^
      photoPath.hashCode ^
      urlId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lecturer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          middleName == other.middleName &&
          photoPath == other.photoPath &&
          urlId == other.urlId;

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
