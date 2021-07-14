import 'package:flutter/material.dart';

class VideoProvider extends ChangeNotifier {
  Offset _cameraOffset = Offset(1, 0);
  Offset _layoutOffset = Offset(1, 0);

  Offset get cameraOffset => _cameraOffset;

  void setCameraOffset(Offset offset) {
    _cameraOffset = offset;

    notifyListeners();
  }

  Offset adjustVideoScreen(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (_cameraOffset == _layoutOffset) {
      return _layoutOffset = Offset(1, 0);
    } else if (_cameraOffset.dy > height / 2 && _cameraOffset.dx < width / 2) {
      return _layoutOffset = Offset(0, 0);
    } else if (_cameraOffset.dy < height / 2 && _cameraOffset.dx > width / 2) {
      return _layoutOffset = Offset(1, 1);
    } else if (_cameraOffset.dy > height / 2 && _cameraOffset.dx > width / 2) {
      return _layoutOffset = Offset(1, 0);
    } else if (_cameraOffset.dy < height / 2 && _cameraOffset.dx < width / 2) {
      return _layoutOffset = Offset(0, 1);
    } else {
      return _layoutOffset = Offset(1, 0);
    }
  }
}
