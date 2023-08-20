import 'dart:convert';

import 'package:bsuir_schedule/data/api/shared_api.dart';

class CurrentWeekApi with SharedApi {
  Future<int?> getCurrentWeek() async {
    const localPath = 'schedule/current-week';

    final response = await getResponse(localPath);

    if (response.statusCode != 200) {
      return null;
    }

    return int.parse(await response.transform(utf8.decoder).join());
  }
}
