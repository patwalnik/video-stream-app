import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_stream_app/routes/custom_router.dart';
import 'package:video_stream_app/routes/routes.dart';
import 'package:video_stream_app/view_model/auth_provider.dart';
import 'package:video_stream_app/view_model/video_provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider<VideoProvider>(
            create: (context) => VideoProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: homeRoute,
        onGenerateRoute: CustomRouter.routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
