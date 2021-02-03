import 'package:app/template/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrintTest extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('vprojects').where('status',isEqualTo: 'complete').get().then((mydata) {
      if(mydata.docs.isEmpty){
        return Loading();
      } else {
        print(mydata.docs.toList().toString());
      }

    });

    return Scaffold(

      body: Card(

        child:

        ListView(
          children: [




          ],
        ),

    )
    );

    // CollectionReference projects = FirebaseFirestore.instance.collection('vprojects');
    //
    // return StreamBuilder<QuerySnapshot>(
    //   stream: projects.snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text('Something went wrong');
    //     }
    //
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Text("Loading");
    //     }
    //
    //     return Scaffold(
    //       body:  ListView(
    //         children: snapshot.data.docs.map((DocumentSnapshot document) {
    //           return ListTile(
    //             title:  Text(document.data()['title']),
    //            subtitle:  Text(document.data()['geolocation'].toString()),
    //           );
    //         }).toList(),
    //       ),
    //     );
    //   },
    // );
  }
}