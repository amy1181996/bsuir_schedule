import 'dart:convert';
import 'dart:io';

import 'package:bsuir_schedule/data/api/model/group.dart';
import 'package:bsuir_schedule/data/api/shared_api.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:flutter/material.dart';

class GroupApi with SharedApi {
  Future<List<Group>?> getAllGroups() async {
    const localPath = 'student-groups';

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
        .where((e) => e['course'] != null)
        .map((e) => ApiGroup.fromJson(e).toGroup())
        .toList();
  }
}
