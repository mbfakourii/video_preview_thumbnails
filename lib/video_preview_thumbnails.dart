import 'dart:async';
import 'dart:typed_data';

import 'package:example/vtt_data_controller.dart';
import 'package:example/vtt_data_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:ui' as ui;
import 'video_preview_thumbnails_painter.dart';
import 'video_preview_thumbnails_controller.dart';

class VideoPreviewThumbnails extends StatefulWidget {
  const VideoPreviewThumbnails({
    super.key,
    required this.vtt,
    this.loading,
    this.error,
    this.baseUrlVttImages,
    this.scale=1.0,
    required this.controller,
  });

  final VideoPreviewThumbnailsController controller;
  final Uint8List vtt;
  final Widget? loading;
  final Widget? error;
  final String? baseUrlVttImages;
  final double scale;

  @override
  State<VideoPreviewThumbnails> createState() => _VideoPreviewThumbnailsState();
}

class _VideoPreviewThumbnailsState extends State<VideoPreviewThumbnails> {
  final List<VttDataModel> images = [];
  VttDataModel currentVttData = VttDataModel.empty;
  late VttDataController vttDataController;
  final dio = Dio();

  ui.Image? thumbnailsImage;

  @override
  void initState() {
    String vttData = String.fromCharCodes(widget.vtt);
    vttDataController = VttDataController.string(vttData);
    currentVttData = vttDataController.vttDataFromMilliseconds(0);

    _getThumbnailImage(vttDataController.vttData.first.imageUrl);

    widget.controller.addListener(
      () {
        setState(() {
          currentVttData = vttDataController.vttDataFromMilliseconds(
            widget.controller.getCurrentTime(),
          );
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (thumbnailsImage != null)
        ? CustomPaint(
            painter: VideoPreviewThumbnailsPainter(
              image: thumbnailsImage!,
              sourceSize: Size(
                currentVttData.w.toDouble(),
                currentVttData.h.toDouble(),
              ),
              offsetX: currentVttData.x,
              offsetY: currentVttData.y,
            ),
            size: Size(
              currentVttData.w.toDouble(),
              currentVttData.h.toDouble(),
            ) * widget.scale,
          )
        : const SizedBox.shrink();
  }

  Future<void> _getThumbnailImage(String url) async {
    // get image
    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    // Convert to ui image
    try {
      thumbnailsImage = await loadImage(
        response.data,
      );
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}
