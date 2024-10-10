import 'package:fluent_ui/fluent_ui.dart';
import 'package:video_player/video_player.dart';

import 'package:video_player_win/video_player_win.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/portada.mp4');
    //controller = VideoPlayerController.file(File("E:\\test_youtube.mp4"));
    controller.initialize().then((value) {
      if (controller.value.isInitialized) {
        controller.play();
        setState(() {});
      } else {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
