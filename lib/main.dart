import 'package:firebase_core/firebase_core.dart';

import './screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import './screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Chat',
            theme: ThemeData(
              primarySwatch: Colors.pink,
              backgroundColor: Colors.pink,
              accentColor: Colors.deepPurple,
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.pink,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: snapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) return SplashScreen();
                      if (userSnapshot.hasData) return ChatScreen();
                      return AuthScreen();
                    },
                    stream: FirebaseAuth.instance.authStateChanges(),
                  ),
          );
        });
  }
}
