import 'dart:developer';

import 'package:app/models/UserMod.dart';
import 'package:app/services/userdb.dart';
import 'package:app/template/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';




class VReward extends StatefulWidget {

  final String rewardid;

  VReward({Key key, @required this.rewardid}) : super(key: key);


  @override
  _VRewardState createState() => _VRewardState();
}

class _VRewardState extends State<VReward> {
  InAppWebViewController webView;

  CollectionReference reward = FirebaseFirestore.instance.collection('vouchers');





  @override
  Widget build(BuildContext context) {


    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Points'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You dont have enough points.'),
                  Text('Please add more points'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }



    final user = Provider.of<UserM>(context);

    return StreamBuilder(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {




        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();

        }

      UserData userData = snapshot.data;

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Rewards"),
              backgroundColor: Colors.pinkAccent,
              elevation: 0.0,
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Points : " + userData.point.toString()),
                  ),
                )
                ,],
            ),
            body: StreamBuilder<DocumentSnapshot>(
                stream: reward.doc(widget.rewardid).snapshots(),
                builder: (BuildContext context,  snapshot) {

                  Future<void> _showMyCode() async {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Enjoy Your Voucher'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( "Your Code :  "+ snapshot.data['code']
                                    ,
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                              ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Done'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  Widget mediaGetter(){

                    if(snapshot.data['imgv'] != null ){
                      return Image.network(snapshot.data['imgv']);
                    }


                    else {
                      return Icon(Icons.person);
                    }

                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();

                  }
                  return Scaffold(
                    body: ListView(

                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [

                              mediaGetter(),
                              ListTile(
                             //   leading: Text(snapshot.data['title']),
                                title: Text(snapshot.data['title']),
                               // subtitle:Text(snapshot.data['reqpoint'].toString(),textAlign: TextAlign.center,),
                                ),

                              ListTile(
                               // leading: Text(snapshot.data['title']),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data['descri']),
                                ),
                                subtitle:Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Required Points : "+snapshot.data['reqpoint'].toString(),textAlign: TextAlign.center,),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:  IconButton(
                                  icon: const Icon(Icons.card_giftcard),
                                  tooltip: 'Claim Code',
                                  onPressed: () async {

                                    if(userData.point < snapshot.data['reqpoint'])
                                    {

                                   await _showMyDialog();

                                   log('baci cheq x cukup oi');
                                    }


                                    else{

                                     await _showMyCode();

                                     int currentpoint= userData.point - snapshot.data['reqpoint'];

                                     DatabaseService(uid: user.uid).updateUserPoint( currentpoint);


                                   int vleft =  snapshot.data['totalv'];
                                        vleft--;
                                        updateVouchers(vleft);
                                      log('baki hang '+ currentpoint.toString());

                                      log('claimed boi');
                                    }
                                    ;
                                  },
                                ),
                              ),


                              // ButtonBar(
                              //   alignment: MainAxisAlignment.start,
                              //   children: [
                              //     FlatButton(
                              //       textColor: const Color(0xFF6200EE),
                              //       onPressed: () {
                              //         // Perform some action
                              //       },
                              //       child: const Text('ACTION 1'),
                              //     ),
                              //     FlatButton(
                              //       textColor: const Color(0xFF6200EE),
                              //       onPressed: () {
                              //         // Perform some action
                              //       },
                              //       child: const Text('ACTION 2'),
                              //     ),
                              //   ],
                              // ),


                            ],
                          ),

                        ),

                      ],


                    ),
                  );
                }),
          ),
        );
      }
    );
  }
  Future<void> updateVouchers(int point) async {
    return reward.doc(widget.rewardid).update({'totalv': point });

  }

}
