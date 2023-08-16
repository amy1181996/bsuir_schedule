import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:flutter/foundation.dart';

class RootScreenViewModel extends ChangeNotifier {
  static final DatabaseHelper _db = DatabaseHelper();

  DatabaseHelper get db => _db;

  Future<void> init() async {
    await _db.init();
  }
}
