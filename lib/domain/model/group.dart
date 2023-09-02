class Group {
  final int id;
  final String name;
  final String facultyAbbrev;
  final String specialityName;
  final String specialityAbbrev;
  final int course;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      facultyAbbrev.hashCode ^
      specialityName.hashCode ^
      specialityAbbrev.hashCode ^
      course.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          facultyAbbrev == other.facultyAbbrev &&
          specialityName == other.specialityName &&
          specialityAbbrev == other.specialityAbbrev &&
          course == other.course;

  Group({
    required this.id,
    required this.name,
    required this.facultyAbbrev,
    required this.specialityName,
    required this.specialityAbbrev,
    required this.course,
  });

  Group copyWith({
    int? id,
    String? name,
    String? facultyAbbrev,
    String? specialityName,
    String? specialityAbbrev,
    int? course,
  }) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        facultyAbbrev: facultyAbbrev ?? this.facultyAbbrev,
        specialityName: specialityName ?? this.specialityName,
        specialityAbbrev: specialityAbbrev ?? this.specialityAbbrev,
        course: course ?? this.course,
      );
}
