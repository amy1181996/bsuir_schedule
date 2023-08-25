import 'package:bsuir_schedule/data/db/model/base_model.dart';

class AddLastUpdate extends BaseModel {
  final int scheduleId;
  final DateTime lastUpdate;

  @override
  int get hashCode => scheduleId.hashCode ^ lastUpdate.hashCode;

  AddLastUpdate({
    required this.scheduleId,
    required this.lastUpdate,
  });

  @override
  Map<String, dynamic> toMap() => {
        'schedule_id': scheduleId,
        'last_update': lastUpdate.toIso8601String(),
        'hash': hashCode,
      };
}

class GetLastUpdate extends BaseModel {
  final int id;
  final int scheduleId;
  final DateTime lastUpdate;

  GetLastUpdate({
    required this.id,
    required this.scheduleId,
    required this.lastUpdate,
  });

  factory GetLastUpdate.fromMap(Map<String, dynamic> map) => GetLastUpdate(
        id: map['id'],
        scheduleId: map['schedule_id'],
        lastUpdate: DateTime.parse(map['last_update']),
      );
}
