import 'package:flutter/foundation.dart' show objectRuntimeType;

class VttDataModel {
  final int number;
  final int start;
  final int end;
  final String text;
  final String imageUrl;
  final int x, y, w, h;

  const VttDataModel({
    required this.number,
    required this.start,
    required this.end,
    required this.text,
    required this.imageUrl,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  static get empty => const VttDataModel(
        text: '',
        imageUrl: '',
        number: -1,
        start: -1,
        end: -1,
        h: 0,
        w: 0,
        x: 0,
        y: 0,
      );
}
