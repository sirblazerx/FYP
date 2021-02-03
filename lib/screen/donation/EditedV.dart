import 'package:app/models/UserMod.dart';
import 'package:app/screen/donation/transactionbranch.dart';

import 'package:app/template/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'EditDonation.dart';



class VEdited extends StatefulWidget {

  final String donationid;
  final String img;
  final String vid;
  final String fb;

  VEdited({Key key, @required this.donationid, this.img, this.vid, this.fb}) : super(key: key);


  @override
  _VEditedState createState() => _VEditedState();
}

class _VEditedState extends State<VEdited> {
  InAppWebViewController webView;

  CollectionReference donation = FirebaseFirestore.instance.collection('donations');

  // String get donationid => widget.donationid;



  final donationController = TextEditingController();





  @override
  void dispose() {
    // TODO: implement dispose
    donationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    final user = Provider.of<UserM>(context);




    return SafeArea(
      child: Scaffold(

        appBar: AppBar(

          title: Text('Donation'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: donation.doc(widget.donationid).snapshots(),
            builder: (BuildContext context,  snapshot) {

              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              Widget mediaGetter(){

                if(snapshot.data['img'] != null ){
                  return Image.network(snapshot.data['img']);
                }
                else if (snapshot.data['uyoutube'] != null){
                  String vid;

                  // Convert Video to ID
                  vid = YoutubePlayer.convertUrlToId(snapshot.data['uyoutube']) ;

                  var _controller = YoutubePlayerController(

                    initialVideoId: vid ,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,


                    ),
                  );

                  return YoutubePlayer(controller: _controller,
                    showVideoProgressIndicator: true,);
                }
                else if (snapshot.data['ufacebook'] != null){



                  var url = snapshot.data['ufacebook'];

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
                      onLoadStart: (InAppWebViewController controller, String url) {

                      },
                      onLoadStop: (InAppWebViewController controller, String url) async {

                      },


                    ),
                  );

                }


                else {
                  return Icon(Icons.person);
                }

              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();

              }
              return
                ListView(

                  children: [


                    GestureDetector(
                      onTap: (){ Navigator.of(context).push(MaterialPageRoute(builder: (context) => (EditDonation( donationid: widget.donationid, img: snapshot.data['img'], vid: snapshot.data['uyoutube'],fb: snapshot.data['ufacebook'],))));},
                      onLongPress: (){


                        Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => TransPageB(projectid: widget.donationid,)));


                          },

                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [


                            mediaGetter(),

                            ListTile(

                              title: Text(snapshot.data['title']),
                              subtitle: Text(snapshot.data['descri'],
                                style: TextStyle(color: Colors.black.withOpacity(0.6)),
                              ),
                            ),

                            ListTile(

                              title: Text('Current Funds :' + snapshot.data['curfund'].toString()),
                              subtitle: Text('Needed Funds : ' + snapshot.data['fundneed'].toString(),
                                style: TextStyle(color: Colors.black.withOpacity(0.6)),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text( snapshot.data['name']
                                ,
                                style: TextStyle(color: Colors.black.withOpacity(0.6)),
                              ),
                            ),

                            // TextField(
                            //  controller:  ,
                            //  ),






                          ],
                        ),

                      ),
                    ),

                  ],




                ); }),
      ),
    );
  }
  DateGetter(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd ').format(now);
    return formattedDate;
  }
}
