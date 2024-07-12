import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class VideoPreviewThumbnailsPainter extends CustomPainter {
  VideoPreviewThumbnailsPainter({
    required this.image,
    required this.sourceSize,
    required this.offsetX,
    required this.offsetY,
  });

  final ui.Image image;
  final Size sourceSize;
  final int offsetX;
  final int offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
        offsetX.toDouble(),
        offsetY.toDouble(),
        sourceSize.width,
        sourceSize.height,
      ),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(VideoPreviewThumbnailsPainter oldDelegate) {
    return true;
  }
}
