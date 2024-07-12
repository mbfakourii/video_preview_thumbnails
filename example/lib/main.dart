import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_preview_thumbnails/video_preview_thumbnails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
        title: 'Video preview thumbnails example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Video preview thumbnails example'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? vttFile;
  VideoPreviewThumbnailsController controller =
      VideoPreviewThumbnailsController();

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            TextButton(
              onPressed: () {
                controller.setCurrentTime(3);
              },
              child: const Text('3'),
            ),
            TextButton(
              onPressed: () {
                controller.setCurrentTime(1400);
              },
              child: const Text('1400'),
            ),
            TextButton(
              onPressed: () {
                controller.setCurrentTime(50000);
              },
              child: const Text('50000'),
            ),
            TextButton(
              onPressed: () {
                controller.setCurrentTime(29000);
              },
              child: const Text('29000'),
            ),
            Container(
              constraints: const BoxConstraints(maxHeight: 150, maxWidth: 300),
              child: (vttFile != null)
                  ? VideoPreviewThumbnails(
                      vtt: vttFile!,
                      controller: controller,
                      scale: 5,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

  Future<Uint8List> loadVtt() async {
    final ByteData data = await rootBundle.load('assets/tooltip.vtt');
    return data.buffer.asUint8List();
  }

  Future<void> load() async {
    vttFile = await loadVtt();
    setState(() {});
  }
}
