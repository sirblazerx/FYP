import 'package:app/models/UserMod.dart';
import 'package:app/payment/Braintree.dart';
import 'package:app/screen/MapTest.dart';
import 'package:app/screen/donation/VDonation.dart';
import 'package:app/screen/donation/donation.dart';
import 'package:app/screen/donation/managedonation.dart';
import 'package:app/screen/donation/transaction.dart';
import 'package:app/screen/event/event.dart';
import 'package:app/screen/event/projectcheck.dart';
import 'package:app/screen/event/vevent.dart';
import 'package:app/screen/reward/rewardpage.dart';
import 'package:app/screen/story/Story.dart';
import 'package:app/screen/story/manageStory.dart';
import 'package:app/services/vidplayer.dart';
import 'package:app/template/CustomListTileStory.dart';
import 'package:app/template/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/screen/profile/profile.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/userdb.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/gwcqp-40547.appspot.com/o/web%20comps%2Fbanner3.jpg?alt=media&token=56eb768c-1d67-48d5-b9e7-d97ab4be25fe',
  'https://firebasestorage.googleapis.com/v0/b/gwcqp-40547.appspot.com/o/web%20comps%2Fgwcqp-01.jpg?alt=media&token=21201a36-b0ec-45ad-9175-04189ffe8d69',
  'https://firebasestorage.googleapis.com/v0/b/gwcqp-40547.appspot.com/o/web%20comps%2Fvon1.jpg?alt=media&token=73d66f60-9838-49da-88a0-2881cf8c0baa',
  'https://firebasestorage.googleapis.com/v0/b/gwcqp-40547.appspot.com/o/web%20comps%2Fvon2.jpg?alt=media&token=ec9e338c-249e-458a-93d2-6adcf26a2717',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
];

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: StreamBuilder(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            UserData me = snapshot.data;
            return Scaffold(
              drawer: Drawer(
                child: StreamBuilder<UserData>(
                    stream: DatabaseService(uid: user.uid).userData,
                    builder: (context, snapshot) {
                      UserData _data = snapshot.data;

                      if (snapshot.hasData) {
                        return ListView(
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            StreamBuilder<UserData>(
                                stream: DatabaseService(uid: user.uid).userData,
                                builder: (context, snapshot) {
                                  UserData _data = snapshot.data;

                                  if (snapshot.hasData) {
                                    return DrawerHeader(
                                      decoration: BoxDecoration(
                                        color: Colors.pinkAccent,
                                      ),
                                      child: _data.profilepic == null
                                          ? Icon(Icons.person_outline)
                                          : Image.network(_data.profilepic),
                                    );
                                  } else {
                                    return Loading();
                                  }
                                }),

                            ListTile(
                                title: Text(
                              'Hello , ' + _data.name,
                              overflow: TextOverflow.fade,
                            )),

                            // Divider(color: Colors.black45,),

                            ListTile(
                              title: Text('Events'),
                              leading: Icon(Icons.event),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Event()),
                                );
                              },
                            ),

                            ListTile(
                              title: Text('Stories'),
                              leading: Icon(Icons.event),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Stories()),
                                );
                              },
                            ),

                            // Divider(color: Colors.black45,),
                            ListTile(
                              leading: Icon(Icons.account_circle),
                              title: Text('Profile'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile()),
                                );
                              },
                            ),

                            //Donation Page
                            //  Divider(color: Colors.black45,),
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text('Donation'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Donation()),
                                );
                              },
                            ),
                            //Payment Page

                            // ListTile(
                            //   leading: Icon(Icons.card_giftcard),
                            //   title: Text('Braintree'),
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => BraintreePayment()),
                            //     );
                            //   },
                            // ),

                            //  Divider(color: Colors.black45,),

                            //  Divider(color: Colors.black45),
                            ListTile(
                              leading: Icon(Icons.card_giftcard),
                              title: Text('Rewards'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RewardPage()),
                                );
                              },
                            ),

                            // About US

                            // Divider(color: Colors.black45,),
                            ListTile(
                              leading: Icon(Icons.map),
                              title: Text('Our Completed Projects'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapTest()),
                                );
                              },
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            FlatButton.icon(
                                onPressed: () async {
                                  await _auth.signOut();
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                label: Text('Logout')),
                          ],
                        );
                      } else {
                        return Loading();
                      }
                    }),
              ),
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'lib/img/icon.png',
                      fit: BoxFit.cover,
                    )),

                // Text('Homepage'),
                backgroundColor: Colors.pinkAccent,
                elevation: 0.0,
              ),
              body: ListView(children: [
                Column(children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                        autoPlayInterval: Duration(seconds: 5),
                        enlargeCenterPage: true,
                        autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                      ),
                      items: imageSliders,
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Latest Projects',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Divider(),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("vprojects")
                        .orderBy('datecreate', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Loading();
                      return Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            DocumentSnapshot projects =
                                snapshot.data.documents[index];

                            Widget mediaGetter() {
                              if (projects['img'] != null) {
                                return Image.network(projects['img']);
                              } else if (projects['uyoutube'] != null) {
                                String vid;

                                // Convert Video to ID
                                vid = YoutubePlayer.convertUrlToId(
                                    projects['uyoutube']);

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
                              } else if (projects['ufacebook'] != null) {
                                InAppWebViewController webView;
                                var url = projects['ufacebook'];

                                return InAppWebView(
                                  initialUrl: url,
                                  initialOptions: InAppWebViewGroupOptions(
                                    crossPlatform: InAppWebViewOptions(
                                        debuggingEnabled: true,
                                        preferredContentMode:
                                            UserPreferredContentMode.DESKTOP),
                                  ),
                                  onWebViewCreated:
                                      (InAppWebViewController controller) {
                                    webView = controller;
                                  },
                                  onLoadStart:
                                      (InAppWebViewController controller,
                                          String url) {},
                                  onLoadStop:
                                      (InAppWebViewController controller,
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
                                          VEvent(projectid: projects.id)));
                                },
                                child: CustomListTile(
                                  // onTap: () {
                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => VDonation(donationid: donate.id)));
                                  // },
                                  user: projects['name'],
                                  description: projects['descri'],
                                  thumbnail: Container(
                                    decoration:
                                        const BoxDecoration(color: Colors.blue),
                                    child: Container(
                                        constraints: BoxConstraints(
                                            minHeight: 100,
                                            minWidth: 100,
                                            maxWidth: 200,
                                            maxHeight: 160),
                                        child: mediaGetter()),
                                  ),
                                  title: projects['title'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Latest Donations',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Divider(),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('donations')
                        .orderBy('datecreate', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Loading();
                      return Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            DocumentSnapshot donate =
                                snapshot.data.documents[index];

                            Widget mediaGetter() {
                              if (donate['img'] != null) {
                                return Image.network(donate['img']);
                              } else if (donate['uyoutube'] != null) {
                                String vid;

                                // Convert Video to ID
                                vid = YoutubePlayer.convertUrlToId(
                                    donate['uyoutube']);

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
                                  onWebViewCreated:
                                      (InAppWebViewController controller) {
                                    webView = controller;
                                  },
                                  onLoadStart:
                                      (InAppWebViewController controller,
                                          String url) {},
                                  onLoadStop:
                                      (InAppWebViewController controller,
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
                                    decoration: const BoxDecoration(
                                        color: Colors.transparent),
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
                ]),
              ]),
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                // child: Icon(Icons.add),s

                curve: Curves.bounceIn,
                children: [
                  // My Story Page
                  SpeedDialChild(
                    child: Icon(Icons.assignment, color: Colors.white),
                    backgroundColor: Colors.deepOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageStory()),
                      );
                    },
                    label: 'Story Page',
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    labelBackgroundColor: Colors.deepOrangeAccent,
                  ),

                  // My Contribution
                  SpeedDialChild(
                    child: Icon(Icons.directions_run, color: Colors.white),
                    backgroundColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectCheck(
                                    userid: user.uid,
                                  )));
                    },
                    label: 'Contribution Page',
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    labelBackgroundColor: Colors.green,
                  ),

                  //My Donation
                  SpeedDialChild(
                    child: Icon(Icons.monetization_on, color: Colors.white),
                    backgroundColor: Colors.blue,
                    onTap: () {
                      if (me.acctype != 'community') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MDonation()),
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransPage()));
                      }
                    },
                    labelWidget: Container(
                      color: Colors.blue,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(6),
                      child: Text('My Donation'),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'Global Women Coalition',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();
}
