import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_stream_app/utils/app_media_query.dart';
import 'package:video_stream_app/view_model/video_provider.dart';

/// This is the stateful widget that the main application instantiates.
class CameraDraggableScreen extends StatefulWidget {
  const CameraDraggableScreen({Key key}) : super(key: key);

  @override
  State<CameraDraggableScreen> createState() => _CameraDraggableScreenState();
}

/// This is the private State class that goes with CameraDraggableScreen.
class _CameraDraggableScreenState extends State<CameraDraggableScreen> {
  List<CameraDescription> cameras;

  CameraController controller;

  int acceptedData = 0;

  @override
  void initState() {
    super.initState();

    initiateCamera();
  }

  Future<void> initiateCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[1], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          controller = controller;
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var querySelector = AppMediaQuery(context);
    return cameras != null && cameras.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Draggable<int>(
                  onDragEnd: (data) {
                    Provider.of<VideoProvider>(context, listen: false)
                        .setCameraOffset(data.offset);
                  },
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Container(
                        height: querySelector.appHeight(50),
                        width: querySelector.appWidth(20),
                        child: (controller == null ||
                                !controller.value.isInitialized)
                            ? CircularProgressIndicator()
                            : CameraPreview(controller)),
                  ),
                  feedback: RotatedBox(
                    quarterTurns: 2,
                    child: Container(
                      color: Colors.transparent,
                      height: querySelector.appHeight(50),
                      width: querySelector.appWidth(20),
                      child: CameraPreview(controller),
                    ),
                  )),
            ],
          )
        : Container();
  }
}
