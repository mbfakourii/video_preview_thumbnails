import 'package:video_preview_thumbnails/video_preview_thumbnails.dart';

/// Parse vtt model data from vtt string file.
///
/// The [data] is vtt string file.
List<VttDataModel> parseFromWebVTTString(final String data) {
  const String webVTTSegment = r'(?:(.+?)(?:\r\n?|\n))?'
      r'(\d{2,}:)?(\d{2}:)(\d{2})\.(\d+)\s+-->\s+(\d{2,}:)?(\d{2}:)(\d{2})\.(\d+)\s*?([^\r\n]*?)(?:\r\n?|\n)'
      r'(?<content>[^\0]*?)'
      r'(?=(?:\r\n?|\n)*?(?:$|(?:.+?(?:\r\n?|\n))?.*?-->))';

  const String webVTTVideoPreviewThumbnails = '(.*)#xywh=(.*),(.*),(.*),(.*)';

  final Iterable<RegExpMatch> captions = RegExp(webVTTSegment).allMatches(data);

  final List<VttDataModel> vttDataModelList = <VttDataModel>[];

  int subtitleNumber = 1;

  for (final RegExpMatch caption in captions) {
    final Duration? start =
        _timestampToMillisecond(caption.groups(<int>[2, 3, 4, 5]));
    final Duration? end =
        _timestampToMillisecond(caption.groups(<int>[6, 7, 8, 9]));
    final String text = caption.group(11) ?? '';
    if (start == null || end == null) {
      continue;
    }
    final Iterable<RegExpMatch> videoPreviewThumbnailsData =
        RegExp(webVTTVideoPreviewThumbnails).allMatches(text);

    vttDataModelList.add(
      VttDataModel(
        number: int.tryParse(caption.group(1) ?? '') ?? subtitleNumber,
        start: start.inMilliseconds,
        end: end.inMilliseconds,
        text: text,
        imageUrl: videoPreviewThumbnailsData.first.group(1)!,
        x: int.parse(videoPreviewThumbnailsData.first.group(2)!),
        y: int.parse(videoPreviewThumbnailsData.first.group(3)!),
        w: int.parse(videoPreviewThumbnailsData.first.group(4)!),
        h: int.parse(videoPreviewThumbnailsData.first.group(5)!),
      ),
    );
    subtitleNumber++;
  }

  return vttDataModelList;
}

Duration? _timestampToMillisecond(final List<String?> segments) {
  final int hours = int.parse(segments[0]?.split(':')[0] ?? '0');
  final int minutes = int.parse(segments[1]?.split(':')[0] ?? '0');
  final int seconds = int.parse(segments[2] ?? '');
  final int milliseconds = int.parse(segments[3] ?? '0');
  if (minutes > 59 || seconds > 59) {
    return null;
  }

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}
