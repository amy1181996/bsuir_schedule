import 'dart:convert';
import 'dart:io';

import 'package:bsuir_schedule/data/api/shared_api.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:intl/intl.dart';

class GroupScheduleLastUpdateApi with SharedApi {
  Future<DateTime?> getGroupScheduleLastUpdate(Group group) async {
    final localPath =
        'last-update-date/student-group?groupNumber=${group.name}';

    HttpClientResponse response;

    try {
      response = await getResponse(localPath);
    } catch (e) {
      print('$e');
      return null;
    }

    if (response.statusCode != 200) {
      return null;
    }

    return DateFormat('dd.MM.yyyy').parse(jsonDecode(
        await response.transform(utf8.decoder).join())['lastUpdateDate']);
  }
}
