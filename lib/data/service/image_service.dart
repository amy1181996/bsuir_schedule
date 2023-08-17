import 'dart:typed_data';

import 'package:bsuir_schedule/data/api/image_api.dart';
import 'package:bsuir_schedule/data/storage/image_storage.dart';

class ImageService {
  static final ImageApi _imageApi = ImageApi();
  static final ImageStorage _imageStorage = ImageStorage();

  Future<Uint8List?> getLecturerPhoto(String photoPath) async {
    Uint8List? photo = await _imageStorage.getLecturerPhoto(photoPath);

    if (photo == null) {
      photo = await _imageApi.getLecturerPhoto(photoPath);

      if (photo != null) {
        await _imageStorage.setLecturerPhoto(photoPath, photo);
      }
    }

    return photo;
  }
}
