
import 'package:flutter/material.dart';
import 'package:app/models/UserMod.dart';
import 'package:app/screen/wrapper.dart';
import 'package:app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserM>.value(
      value: AuthService().user,





        child: MaterialApp(

          home: Wrapper(),

          theme: ThemeData(

            accentColor: Colors.pinkAccent,
            primaryColor: Colors.pink[60],
          ),
        ),
      );

  }
}

//material app
