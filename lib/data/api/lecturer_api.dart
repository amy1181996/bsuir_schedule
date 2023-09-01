import 'dart:convert';
import 'dart:io';

import 'package:bsuir_schedule/data/api/model/lecturer.dart';
import 'package:bsuir_schedule/data/api/shared_api.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:flutter/material.dart';

class LecturerApi with SharedApi {
  Future<List<Lecturer>?> getAllLecturers() async {
    const localPath = 'employees/all';

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

    return (jsonDecode(await response.transform(utf8.decoder).join()) as List)
        .map((e) => ApiLecturer.fromJson(e).toLecturer())
        .toList();
  }
}
