
import 'package:app/models/UserMod.dart';
import 'package:app/screen/reward/vreward.dart';
import 'package:app/services/userdb.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/template/loading.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';


class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserM>(context);

    return StreamBuilder(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        UserData userData = snapshot.data;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Rewards'),
              centerTitle: true,
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
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('vouchers')
                  .where('totalv',isGreaterThan: 0)
                  .snapshots(),
              builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();

              }

              if (snapshot.hasError) {
                return Text('Something went wrong');
              }


                return GridView.builder(

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2
                    ),
                    itemCount: snapshot?.data?.documents?.length ?? 0,
                    itemBuilder: (context, index) {

                      DocumentSnapshot donate = snapshot.data.documents[index];


                      return GestureDetector(
                        onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VReward(rewardid: donate.id)));
                      },
                        child: Card(

                          child: Column(
                              children: [

                                Container(
                                  height: 70,
                                    child: Image.network(donate['imgv'])) ,


                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(donate['title'],overflow: TextOverflow.ellipsis,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text( "Required Points : "+donate['reqpoint'].toString()
                              ,
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          //  Text(donate['descri'],overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          // ),

                        Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Vouchers Left : "+donate["totalv"].toString()),
                        ),
                    ]),
                        ),
                      );
                    },
                  );

              },
            ),
          ),
        );
      }
    );
  }
}
