import 'dart:convert';
import 'dart:io';

import 'package:bsuir_schedule/data/api/shared_api.dart';

class CurrentWeekApi with SharedApi {
  Future<int?> getCurrentWeek() async {
    const localPath = 'schedule/current-week';

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

    return int.parse(await response.transform(utf8.decoder).join());
  }
}
