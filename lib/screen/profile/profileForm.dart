import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/models/UserMod.dart';
import 'package:app/services/userdb.dart';
import 'package:app/template/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:app/template/template.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  // profiles values

  String _currentacctype;
  String _currentaddress;
  String _currentname;
  String _currentcontact;
  String _currentcountry;
  String _currentprofilepic;
  int _currentpoint;
  int _currentTVol;
  int _currentTDon;
  int _currentnnotification;
  String _currentfbpage;
  String _currentweb;
  String imgUrl;
  String _sex;
  String _userid;
  int _tprojectjoin;

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: <Widget>[
                          SizedBox(height: 20.0),

                          Text(
                            'Update Your Profile',
                            style: TextStyle(fontSize: 30.0),
                          ),

                          SizedBox(
                            height: 20.0,
                          ),

                          //  (userData.profilepic != null)  ? Image.network(userData.profilepic) : Placeholder(fallbackHeight:   200.0,fallbackWidth: double.infinity,),
                          (_currentprofilepic != null)
                              ? Image.network(_currentprofilepic)
                              : Placeholder(
                                  fallbackHeight: 200.0,
                                  fallbackWidth: double.infinity,
                                ),

                          SizedBox(
                            height: 20.0,
                          ),

                          RaisedButton(
                            child: Text('Upload Image'),
                            color: Colors.lightGreen,
                            onPressed: () {
                              uploadImage();
                              //  DatabaseService(uid: user.uid).updateProfilePic(_currentprofilepic);
                            },
                          ),

                          SizedBox(height: 10.0),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Name :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData.name,
                                  decoration: textInputDecoration,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter Your  name' : null,
                                  onChanged: (val) =>
                                      setState(() => _currentname = val),
                                ),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Contact Number :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData.contact,
                                  decoration: textInputDecoration,
                                  validator: (val) => val.isEmpty
                                      ? 'Enter Contact Number'
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _currentcontact = val),
                                ),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Address :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData.address,
                                  decoration: textInputDecoration,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter Address' : null,
                                  onChanged: (val) =>
                                      setState(() => _currentaddress = val),
                                ),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Address :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData.sex,
                                  decoration: textInputDecoration,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter Sex' : null,
                                  onChanged: (val) =>
                                      setState(() => _sex = val),
                                ),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Country of  Origin :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData.country,
                                  decoration: textInputDecoration,
                                  validator: (val) => val.isEmpty
                                      ? 'Enter Your Country '
                                      : null,
                                  onChanged: (val) =>
                                      setState(() => _currentcountry = val),
                                ),
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  'Facebook Page URL :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                subtitle: TextFormField(
                                  initialValue: userData.fbpage,
                                  decoration: textInputDecoration,
                                  onChanged: (val) =>
                                      setState(() => _currentfbpage = val),
                                ),
                              ),
                            ),
                          ),

                          if (userData.acctype != 'community')
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    'Official Website :',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  subtitle: TextFormField(
                                    initialValue: userData.officialweb,
                                    decoration: textInputDecoration,
                                    onChanged: (val) =>
                                        setState(() => _currentweb = val),
                                  ),
                                ),
                              ),
                            ),

                          SizedBox(height: 40.0),

                          RaisedButton(
                              color: Colors.green[400],
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  log(_currentprofilepic);
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(
                                          _currentname ?? userData.name,
                                          userData.acctype,
                                          _currentcontact ?? userData.contact,
                                          _currentaddress ?? userData.address,
                                          _currentcountry ?? userData.country,
                                          _currentprofilepic ??
                                              userData.profilepic,
                                          userData.TVol,
                                          userData.TDon,
                                          userData.point,
                                          userData.nnotification,
                                          _currentfbpage ?? userData.fbpage,
                                          _currentweb ?? userData.officialweb,
                                          userData.tprojectjoin,
                                          user.uid,
                                          _sex ?? userData.sex);

                                  Navigator.pop(context);
                                }
                              }),
                        ]),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Loading();
            }
          },
        ),
      ),
    );
  }

  uploadImage() async {
    final _picker = ImagePicker();
    final _storage = FirebaseStorage.instance;

    PickedFile image;

    //Check Permission
    await Permission.photos.request();

    var permissionstatus = await Permission.photos.status;

    if (permissionstatus.isGranted) {
      //Select Image

      image = await _picker.getImage(source: ImageSource.gallery);

      var file = File(image.path);
      var name = basename(image.path);

      if (image != null) {
        //Upload to Firebase

        var snapshot = await _storage.ref().child(name).putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        //  log(downloadUrl);

        setState(() {
          _currentprofilepic = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Please enable permission for photos and try again');
    }
  }
}
