import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_stream_app/routes/routes.dart';
import 'package:video_stream_app/utils/app_media_query.dart';
import 'package:video_stream_app/view_model/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var actions = Provider.of<AuthProvider>(context, listen: false);
    var querySelector = AppMediaQuery(context);

    return Scaffold(
      body: StreamBuilder<User>(
        stream: actions.autheticate(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Container(
              child: snapshot.data != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome, ${actions?.userCredential?.displayName}",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: querySelector.appHeight(20),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(videoRoute);
                            },
                            child: Text("Play Video"),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextButton(
                              onPressed: () async {
                                await actions.signOut();
                              },
                              child: Text("Log out")),
                        ],
                      ),
                    )
                  : Center(
                      child: TextButton(
                          onPressed: () async {
                            await actions.signInWithGoogle();
                          },
                          child: Text("Log in with google")),
                    ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
