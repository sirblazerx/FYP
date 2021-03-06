import 'dart:developer';
import 'dart:io';
import 'package:app/models/UserMod.dart';
import 'package:app/services/DonationService.dart';
import 'package:app/services/StoryService.dart';
import 'package:app/services/userdb.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddStory extends StatefulWidget {
  @override
  _AddStoryState createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  CollectionReference story = FirebaseFirestore.instance.collection('storys');

  InAppWebViewController webView;

  final _fkey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String _curtitle;
  String _curdescri;
  String _name;
  String _curdate;
  String _curimg;
  String _fb;
  String _yt;
  String _acctype;
  String _userid;
  String _curcountry;
  String _url;

  final number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Story'),
            centerTitle: true,
            backgroundColor: Colors.pinkAccent,
          ),
          body: Container(
            alignment: Alignment.center,
            child: ListView(
              children: [
                Form(
                    key: _fkey,
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        (_curimg != null)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    constraints: BoxConstraints(maxHeight: 290),
                                    child: Image.network(_curimg)),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: mediapicker(),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            initialValue: null,
                            onChanged: (val) => setState(() => _url = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Video URL",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(flex: 1),
                            RaisedButton.icon(
                                icon: Icon(Icons.book),
                                label: Text('Facebook'),
                                onPressed: () {
                                  _fb = _url;
                                  _yt = null;
                                  _curimg = null;

                                  //  log(_fb + 'FB');
                                }),
                            Spacer(
                              flex: 1,
                            ),
                            RaisedButton.icon(
                                icon: Icon(Icons.play_arrow),
                                label: Text('Youtube'),
                                onPressed: () {
                                  _yt = _url;
                                  _fb = null;
                                  _curimg = null;

                                  //    log( _yt+'YT');
                                }),
                            Spacer(
                              flex: 1,
                            ),
                            RaisedButton.icon(
                                icon: Icon(Icons.person_add),
                                label: Text('Image'),
                                onPressed: () {
                                  _yt = null;
                                  _fb = null;

                                  uploadImage();
                                }),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                        Text('Please fill in the credentials'),
                        SizedBox(height: 20.0),
                        Text(_curtitle == null ? "MEEEEP" : _curtitle),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            initialValue: null,
                            validator: (val) =>
                                val.isEmpty ? 'Enter title' : null,
                            onChanged: (val) => setState(() => _curtitle = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Title",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            initialValue: null,
                            minLines: 3,
                            maxLines: 5,
                            validator: (val) => val.isEmpty
                                ? 'Enter Donation Description'
                                : null,
                            onChanged: (val) =>
                                setState(() => _curdescri = val),
                            style: style,
                            decoration: InputDecoration(
                                labelText: "Description",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        StreamBuilder<UserData>(
                            stream: DatabaseService(uid: user.uid).userData,
                            builder: (context, snapshot) {
                              UserData userData = snapshot.data;

                              return RaisedButton.icon(
                                  onPressed: () async {
                                    var nsid = Uuid().v4();

                                    if (_yt != null) {
                                      String vid;

                                      // Convert Video to ID
                                      vid = YoutubePlayer.convertUrlToId(_yt);

                                      _yt = 'https://www.youtube.com/embed/' +
                                          vid;
                                    }

                                    print('This is cur _yt ' +
                                        _curimg.toString());

                                    if (_fkey.currentState.validate()) {
                                      await StoryService(sid: nsid)
                                          .updateStoryData(
                                        storyid: nsid,
                                        userid: user.uid,
                                        acctype: userData.acctype,
                                        datecreate: DateGetter(),
                                        descri: _curdescri,
                                        title: _curtitle,
                                        img: _curimg,
                                        tcomment: 0,
                                        totlike: 0,
                                        uyoutube: _yt,
                                        ufacebook: _fb,
                                        tlike: [],
                                        name: userData.name,
                                      );

                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(Icons.save_alt),
                                  label: Text('Save'));
                            })
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateGetter() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd ').format(now);
    return formattedDate;
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

        //   log(downloadUrl);

        // Setstate

        setState(() {
          _curimg = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Please enable permission for photos and try again');
    }
  }

  Widget mediapicker() {
    if (_curimg != null) {
    } else if (_yt != null) {
      String vid;

      // Convert Video to ID
      vid = YoutubePlayer.convertUrlToId(_yt);

      var _controller = YoutubePlayerController(
        initialVideoId: (vid == null) ? vid = 'Null' : vid,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );

      return YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      );
    } else if (_fb != null) {
      var url = _fb;

      return Container(
        height: 290,
        child: InAppWebView(
          initialUrl: url,
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                debuggingEnabled: true,
                preferredContentMode: UserPreferredContentMode.MOBILE),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {},
          onLoadStop: (InAppWebViewController controller, String url) async {},
        ),
      );
    } else {
      return Placeholder(
        fallbackHeight: 200.0,
        fallbackWidth: double.infinity,
      );
    }
  }
}
