
import 'package:video_preview_thumbnails/vtt_data_model.dart';

List<VttDataModel> parseFromWebVTTString(String data) {
  final subtitles = <VttDataModel>[];
  final captions = RegExp(_webVTTSegment).allMatches(data);

  int subtitleNumber = 1;

  for (final caption in captions) {
    final start = _timestampToMillisecond(caption.groups([2, 3, 4, 5]));
    final end = _timestampToMillisecond(caption.groups([6, 7, 8, 9]));
    final text = caption.group(11) ?? '';
    if (start == null || end == null) {
      continue;
    }
    final videoPreviewThumbnailsData =
        RegExp(_webVTTVideoPreviewThumbnails).allMatches(text);

    subtitles.add(VttDataModel(
      number: int.tryParse(caption.group(1) ?? '') ?? subtitleNumber,
      start: start.inMilliseconds,
      end: end.inMilliseconds,
      text: text,
      imageUrl: videoPreviewThumbnailsData.first.group(1)!,
      x: int.parse(videoPreviewThumbnailsData.first.group(2)!),
      y: int.parse(videoPreviewThumbnailsData.first.group(3)!),
      w: int.parse(videoPreviewThumbnailsData.first.group(4)!),
      h: int.parse(videoPreviewThumbnailsData.first.group(5)!),
    ));
    subtitleNumber++;
  }

  return subtitles;
}

Duration? _timestampToMillisecond(List<String?> segments) {
  final hours = int.parse(segments[0]?.split(':')[0] ?? '0');
  final minutes = int.parse(segments[1]?.split(':')[0] ?? '0');
  final seconds = int.parse(segments[2] ?? '');
  final milliseconds = int.parse(segments[3] ?? '0');
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

const String _webVTTSegment = r'(?:(.+?)(?:\r\n?|\n))?'
    r'(\d{2,}:)?(\d{2}:)(\d{2})\.(\d+)\s+-->\s+(\d{2,}:)?(\d{2}:)(\d{2})\.(\d+)\s*?([^\r\n]*?)(?:\r\n?|\n)'
    r'(?<content>[^\0]*?)'
    r'(?=(?:\r\n?|\n)*?(?:$|(?:.+?(?:\r\n?|\n))?.*?-->))';

const String _webVTTVideoPreviewThumbnails = r'(.*)#xywh=(.*),(.*),(.*),(.*)';
