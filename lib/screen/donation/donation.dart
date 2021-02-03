import 'package:app/screen/donation/VDonation.dart';
import 'package:app/template/CustomListTileStory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/template/loading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Donation extends StatefulWidget {
  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donation'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('donations')
              .orderBy('datecreate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            return Card(
              child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot donate = snapshot.data.documents[index];

                  Widget mediaGetter() {
                    if (donate['img'] != null) {
                      return Image.network(donate['img']);
                    } else if (donate['uyoutube'] != null) {
                      String vid;

                      // Convert Video to ID
                      vid = YoutubePlayer.convertUrlToId(donate['uyoutube']);

                      var _controller = YoutubePlayerController(
                        initialVideoId: vid,
                        flags: YoutubePlayerFlags(
                          autoPlay: false,
                          mute: true,
                        ),
                      );
                      //    log('null');
                      return YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                      );
                    } else if (donate['ufacebook'] != null) {
                      InAppWebViewController webView;
                      var url = donate['ufacebook'];

                      return InAppWebView(
                        initialUrl: url,
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                              debuggingEnabled: true,
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

                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                VDonation(donationid: donate.id)));
                      },
                      child: CustomListTile(
                        // onTap: () {
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => VDonation(donationid: donate.id)));
                        // },
                        user: donate['name'],
                        description: donate['descri'],
                        thumbnail: Container(
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          child: Container(
                              constraints: BoxConstraints(
                                  minHeight: 100,
                                  minWidth: 100,
                                  maxWidth: 200,
                                  maxHeight: 160),
                              child: mediaGetter()),
                        ),
                        title: donate['title'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
