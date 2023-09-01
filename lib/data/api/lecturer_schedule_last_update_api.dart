import 'dart:convert';
import 'dart:io';

import 'package:bsuir_schedule/data/api/shared_api.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LecturerScheduleLastUpdateApi with SharedApi {
  Future<DateTime?> getLecturerLastUpdate(Lecturer lecturer) async {
    final localPath = 'last-update-date/employee?url-id=${lecturer.urlId}';

    HttpClientResponse response;

    try {
      response = await getResponse(localPath);
    } catch (e) {
      debugPrint('$e');
      return null;
    }

    if (response.statusCode != 200) {
      return null;
    }

    return DateFormat('dd.MM.yyyy').parse(jsonDecode(
        await response.transform(utf8.decoder).join())['lastUpdateDate']);
  }
}
