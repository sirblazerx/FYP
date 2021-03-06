import 'package:app/models/UserMod.dart';
import 'package:app/screen/donation/VDonation.dart';
import 'package:app/services/userdb.dart';
import 'package:app/template/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TransPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final user = Provider.of<UserM>(context);


    return SafeArea(
      child: Scaffold(




              body: StreamBuilder(
                  stream: DatabaseService(uid: user.uid).userData,
                  builder: (context, snapshot) {

                    UserData userData = snapshot.data;
                    return SafeArea(
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text('My Transactions'),
                          centerTitle: true,
                          backgroundColor: Colors.pinkAccent,
                          elevation: 0.0,
                          actions: [

                            ],
                        ),
                        body: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('transcations')
                              .where('donatorid', isEqualTo: user.uid)
                              .snapshots(),
                          builder: (context, snapshot) {

                            if (snapshot.data == null) return Loading();

                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1
                              ),
                              itemCount: snapshot?.data?.documents?.length ?? 0,
                              itemBuilder: (context, index) {

                                DocumentSnapshot donate = snapshot.data.documents[index];


                                return GestureDetector(
                                  onTap: (){ Navigator.of(context).push(MaterialPageRoute(builder: (context) => VDonation(donationid: donate['projectid'])));},
                                  child: Card(

                                    child: Column(
                                        children: [


                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Transaction ID : '+donate['transid'],overflow: TextOverflow.ellipsis,),
                                          ),

                                          ListTile(

                                            title:Text(donate['projectname'],overflow: TextOverflow.ellipsis,),
                                            subtitle: Text(donate['status'],overflow: TextOverflow.ellipsis,),
                                            trailing: Text(donate['platform'],overflow: TextOverflow.ellipsis,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text( "Amount Donated : "+ donate['total'].toString()
                                              ,
                                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                            ),
                                          ),
                                          //  Text(donate['descri'],overflow: TextOverflow.ellipsis,
                                          //   style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          // ),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Time of Donation : "+donate["time"].toString()),
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
              ),),
    );





  }
}
