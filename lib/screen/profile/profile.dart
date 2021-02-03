import 'package:flutter/material.dart';
import 'package:app/screen/profile/profileForm.dart';
import 'package:app/screen/profile/profile_list.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
            title: Text('Your Profile'),
            backgroundColor: Colors.pinkAccent,
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileForm()),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile')),
            ]),
        body: ProfileList(),
      ),
    );
  }
}
