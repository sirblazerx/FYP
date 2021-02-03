import 'package:app/models/commentsMod.dart';
import 'package:app/models/participantMod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantService {
  final String partid;

  ParticipantService({this.partid});


  //collection ref

  final CollectionReference participants =
  FirebaseFirestore.instance.collection('participants');



// Update/Create Data to Collection

  // User Data

  Future updateComments(String contact, String name , String projectid , String status  , String userid) async {
    return await participants.doc(partid).set({


      'contact' : contact,
      'name' : name,
      'projectid' : projectid,
      'status' : status,
      'userid' : userid,




    });
  }

  Future withdraw() async {
    return await participants.doc(partid).delete();




  }





  ParticipantData _participant (DocumentSnapshot snapshot) {
    return ParticipantData(

     contact: 'contact',
      name:  'name',
      projectid: 'projectid',
        status : 'status',
      userid: 'userid',







    );

  }






  //Stream


  // get user data stream
  Stream<ParticipantData> get partData {
    return participants.doc(partid).snapshots().map(_participant);
  }
}