import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_stream_app/constants/constants.dart';
import 'package:video_stream_app/utils/app_media_query.dart';
import 'package:video_stream_app/view_model/video_provider.dart';
import 'package:video_stream_app/widgets/camera_drag.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _hideVideoButtons = true;
  double initialVolume = 20;

  @override
  void initState() {
    _controller = VideoPlayerController.network(videoFileUrl);

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var querySelector = AppMediaQuery(context);

    Widget _positionedWidget({Widget child, Offset offset}) {
      print("pirs $offset");
      if (offset == Offset(0, 0)) {
        return Positioned(
            bottom: querySelector.appHeight(20),
            left: querySelector.appWidth(5),
            child: child);
      } else if (offset == Offset(1, 0)) {
        return Positioned(
            bottom: querySelector.appHeight(20),
            right: querySelector.appWidth(5),
            child: child);
      } else if (offset == Offset(1, 1)) {
        return Positioned(
            top: querySelector.appHeight(20),
            right: querySelector.appWidth(5),
            child: child);
      } else {
        return Positioned(
            top: querySelector.appHeight(20),
            left: querySelector.appWidth(5),
            child: child);
      }
    }

    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size?.width ?? 0,
                  height: _controller.value.size?.height ?? 0,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _hideVideoButtons = !_hideVideoButtons;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_controller),
                          _hideVideoButtons
                              ? Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          // If the video is playing, pause it.
                                          if (_controller.value.isPlaying) {
                                            _controller.pause();
                                            _hideVideoButtons =
                                                !_hideVideoButtons;
                                          } else {
                                            // If the video is paused, play it.
                                            _controller.play();
                                            _hideVideoButtons =
                                                !_hideVideoButtons;
                                          }
                                        });
                                      },
                                      child: Text("Play me",
                                          style: TextStyle(fontSize: 50))),
                                )
                              : Container(),
                          _hideVideoButtons
                              ? Positioned(
                                  left: querySelector.appWidth(5),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Slider(
                                      value: _controller.value.volume,
                                      min: 0,
                                      max: 1,
                                      onChanged: (newValue) {
                                        _controller.setVolume(newValue);
                                        setState(() {
                                          initialVolume = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Container(),
                          _positionedWidget(
                              child: CameraDraggableScreen(),
                              offset: Provider.of<VideoProvider>(context)
                                  .adjustVideoScreen(context))
                        ],
                      )),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
