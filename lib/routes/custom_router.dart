import 'package:flutter/material.dart';
import 'package:video_stream_app/routes/routes.dart';
import 'package:video_stream_app/screens/home_screen.dart';
import 'package:video_stream_app/screens/video_player.dart';

class CustomRouter {
  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case videoRoute:
        return MaterialPageRoute(builder: (_) => VideoPlayerScreen());
      default:
        return null;
    }
  }
}
