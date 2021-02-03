import 'package:app/models/commentsMod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final String cid;


  CommentService({ this.cid});

  //collection ref

  final CollectionReference comment =
  FirebaseFirestore.instance.collection('comments');


// Update/Create Data to Collection

  // User Data

  Future updateComments(String content, String from , String profilepic , String time , String to , String userid) async {
    return await comment.doc(cid).set({


     'content' : content,
      'from' : from,
      'profilepic' : profilepic,
      'time' : time,
       'userid' : userid,
        'to' : to,



    });
  }





  CommentData _comment (DocumentSnapshot snapshot) {
    return CommentData(
      content: snapshot.data()['content'],
      from: snapshot.data()['from'],
      profilepic: snapshot.data()['prorfilepic'],
      time: snapshot.data()['time'],
      to : snapshot.data()['to'],
      userid: snapshot.data()['userid'],







    );

  }






  //Stream


  // get user data stream
  Stream<CommentData> get userData {
    return comment.doc(cid).snapshots().map(_comment);
  }
}