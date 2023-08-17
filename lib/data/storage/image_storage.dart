import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class ImageStorage {
  Future<Uint8List?> getLecturerPhoto(String photoPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$photoPath';
    final file = File(path);
    if (!file.existsSync()) {
      return null;
    }
    return await file.readAsBytes();
  }

  Future<void> setLecturerPhoto(String photoPath, Uint8List photo) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$photoPath';
    final file = File(path);
    await file.writeAsBytes(photo);
  }
}
