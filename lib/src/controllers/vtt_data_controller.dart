import 'package:video_preview_thumbnails/video_preview_thumbnails.dart';

class VttDataController {
  VttDataController.string(this.fileContents)
      : _vttData = parseFromWebVTTString(fileContents);
  final String fileContents;

  /// Get vtt data model list.
  List<VttDataModel> get vttData => _vttData;

  final List<VttDataModel> _vttData;

  /// Check vttData list is empty.
  bool get isEmpty => vttData.isEmpty;

  /// Check vttData list is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Get [VttDataModel] data from milliseconds.
  VttDataModel vttDataFromMilliseconds(final int milliseconds) {
    final VttDataModel selectedVttData = _vttData.lastWhere(
      (final VttDataModel data) =>
          milliseconds >= (data.start) && milliseconds <= (data.end),
      orElse: () => VttDataModel.empty,
    );
    return selectedVttData;
  }
}
