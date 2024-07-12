import 'package:flutter/material.dart';

class VideoPreviewThumbnailsController
    extends ValueNotifier<VideoPreviewThumbnailsValue> {
  VideoPreviewThumbnailsController()
      : super(const VideoPreviewThumbnailsValue(currentTimeMilliseconds: 0));

  /// Set current time base milliseconds.
  ///
  /// The [currentTimeMilliseconds].
  void setCurrentTime(final int currentTimeMilliseconds) {
    value = value.copyWith(
      currentTimeMilliseconds: currentTimeMilliseconds,
    );
  }

  /// Get current time base milliseconds
  int getCurrentTime() => value.currentTimeMilliseconds;
}

@immutable
class VideoPreviewThumbnailsValue {
  const VideoPreviewThumbnailsValue({
    required this.currentTimeMilliseconds,
  });

  final int currentTimeMilliseconds;

  VideoPreviewThumbnailsValue copyWith({
    required final int currentTimeMilliseconds,
  }) =>
      VideoPreviewThumbnailsValue(
        currentTimeMilliseconds: currentTimeMilliseconds,
      );
}
