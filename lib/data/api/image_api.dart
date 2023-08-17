import 'dart:typed_data';

import 'package:bsuir_schedule/data/api/shared_api.dart';

class ImageApi with SharedApi {
  Future<Uint8List?> getLecturerPhoto(String photoPath) async {
    final String localPath = 'employees/photo/$photoPath';

    final response = await getResponse(localPath);

    if (response.statusCode != 200) {
      return null;
    }

    final bytes = await response.fold<BytesBuilder>(
      BytesBuilder(),
      (previous, element) => previous..add(element),
    );
    return bytes.takeBytes();
  }
}
