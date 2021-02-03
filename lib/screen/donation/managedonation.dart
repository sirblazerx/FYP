import 'package:app/models/UserMod.dart';
import 'package:app/screen/donation/EditDonation.dart';
import 'package:app/screen/donation/EditedV.dart';
import 'package:app/screen/donation/createdonation.dart';
import 'package:app/screen/donation/transaction.dart';
import 'package:app/screen/donation/transactionbranch.dart';
import 'package:app/services/userdb.dart';
import 'package:app/template/CustomListTileStory.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/template/loading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MDonation extends StatefulWidget {
  @override
  _MDonationState createState() => _MDonationState();
}

class _MDonationState extends State<MDonation> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Donation'),
          backgroundColor: Colors.pinkAccent,
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("donations")
              .where('userid', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return Loading();
            return Card(
              child: ListView.builder(

                shrinkWrap: true,
                itemCount: snapshot?.data?.documents?.length ?? 0,
                itemBuilder: (context, index) {
                  DocumentSnapshot donate = snapshot.data.documents[index];
                  Widget mediaGetter(){

                    if(donate['img'] != null ){
                      return Image.network(donate['img']);
                    }
                    else if (donate['uyoutube'] != null){
                      String vid;

                      // Convert Video to ID
                      vid = YoutubePlayer.convertUrlToId(donate['uyoutube']) ;

                      var _controller = YoutubePlayerController(

                        initialVideoId: vid ,
                        flags: YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      );
                      //    log('null');
                      return YoutubePlayer(controller: _controller,
                        showVideoProgressIndicator: true,);
                    }
                    else if (donate['ufacebook'] != null){

                      InAppWebViewController webView;
                      var url = donate['ufacebook'];

                      return InAppWebView(

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


                      );

                    } else {
                      return Icon(Icons.person);
                    }

                  }

                  return Card(
                    child:InkWell(
                      onTap: () {


                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => (VEdited( donationid: donate.id, img: donate['img'], vid: donate['uyoutube'],fb: donate['ufacebook'],))));


                      },


                      child: CustomListTile(

                        // onTap: () {
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => VDonation(donationid: donate.id)));
                        // },
                        user: donate['name'],
                        description: donate['descri'],
                        thumbnail: Container(
                          decoration: const BoxDecoration(color: Colors.transparent),
                          child :

                          Container(

                              constraints: BoxConstraints(minHeight: 100,minWidth: 120, maxWidth: 300,maxHeight: 300),

                              child: mediaGetter())
                          ,

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
        floatingActionButton: StreamBuilder(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            UserData _datauser = snapshot.data;
            return FloatingActionButton(
              onPressed: (){

                if(_datauser.acctype != 'community'){

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDonation()),

                  );
                }else{


                }

              },
              child:
            Icon(Icons.add)  ,);
          }
        ),
      ),
    );
  }
}
