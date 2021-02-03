import 'package:flutter/material.dart';
import 'package:app/models/UserMod.dart';
import 'package:app/screen/authenticate/authenticate.dart';
import 'package:app/screen/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
    //will return Home or Authenticate based on user
  }
}
