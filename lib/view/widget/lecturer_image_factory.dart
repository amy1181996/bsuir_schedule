import 'dart:typed_data';

import 'package:bsuir_schedule/data/service/image_service.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:flutter/material.dart';

class LecturerImageFactory {
  static final ImageService _imageService = ImageService();

  Widget fetchImage(
      {required Lecturer? lecturer,
      required double radius,
      required double borderSize}) {
    if (lecturer == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        child: CircleAvatar(
          radius: radius - borderSize,
          child: const Icon(Icons.person_2_outlined),
        ),
      );
    }

    Future<Uint8List?>? image =
        _imageService.getLecturerPhoto(lecturer.photoPath);

    return FutureBuilder(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: radius,
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: Image.memory(snapshot.data!).image,
          );
        } else {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: radius - borderSize,
              child: const Icon(Icons.person_2_outlined),
            ),
          );
        }
      },
    );
  }
}
