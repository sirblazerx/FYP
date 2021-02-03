import 'package:app/screen/story/VMoreStory.dart';
import 'package:app/models/UserMod.dart';
import 'package:app/screen/story/manageStory.dart';
import 'package:app/template/CustomListTileStory.dart';
import 'package:app/template/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Story Page'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('storys')
              .orderBy('datecreate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot?.data?.documents?.length ?? 0,
              itemBuilder: (context, index) {
                DocumentSnapshot _data = snapshot.data.documents[index];

                // Declaration of FB,YT vids

                Widget mediaGetter() {
                  if (_data['img'] != null) {
                    return Image.network(_data['img']);
                  } else if (_data['uyoutube'] != null) {
                    String vid;

                    // Convert Video to ID
                    vid = YoutubePlayer.convertUrlToId(_data['uyoutube']);

                    var _controller = YoutubePlayerController(
                      initialVideoId: vid,
                      flags: YoutubePlayerFlags(
                        autoPlay: false,
                        mute: true,
                      ),
                    );
                    //log('null');
                    return YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    );
                  } else if (_data['ufacebook'] != null) {
                    InAppWebViewController webView;
                    var url = _data['ufacebook'];

                    return InAppWebView(
                      initialUrl: url,
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            debuggingEnabled: true,
                            transparentBackground: true,
                            preferredContentMode:
                                UserPreferredContentMode.MOBILE),
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                      },
                      onLoadStart:
                          (InAppWebViewController controller, String url) {},
                      onLoadStop: (InAppWebViewController controller,
                          String url) async {},
                    );
                  } else {
                    return Icon(Icons.person);
                  }
                }
                // Get Video URL

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VStory(
                                storyid: _data.id,
                              )));
                    },
                    child: CustomListTile(
                      user: _data['name'],
                      description: _data['descri'],
                      thumbnail: Container(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Container(
                            constraints: BoxConstraints(
                                minHeight: 100,
                                minWidth: 100,
                                maxWidth: 250,
                                maxHeight: 160),
                            child: mediaGetter()),
                      ),
                      title: _data['title'],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ManageStory()));
          },
        ),
      ),
    );
  }
}
