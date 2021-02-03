import 'package:app/models/DonationMod.dart';
import 'package:app/models/StoryMod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/VolunteerProjectMod.dart';
import 'package:app/models/UserMod.dart';

class StoryService {
  final String sid;




  //collection ref

  final CollectionReference story =
  FirebaseFirestore.instance.collection('storys');

  StoryService({this.sid});


// Update/Create Data to Collection

  // User Data

  Future updateStoryData({String name, String acctype, String datecreate,
      String descri, String img, int tcomment,String title,List tlike,String ufacebook,String userid, String uyoutube , String storyid , int totlike}) async {
    return await story.doc(sid).set({
      'name': name,
      'acctype': acctype,
      'datecreate': datecreate,
      'descri': descri,
      'img': img,
      'tcomment': tcomment,
      'title' : title,
      'tlike' : tlike,
      'ufacebook' : ufacebook,
      'userid' : userid,
      'uyoutube' : uyoutube,
      'storyid' : storyid,
      'totlike' : totlike,



    });
  }


  Future updateUserPoint(int point) async {
    return await story.doc(sid).update({

      'tcomment' : point,


    });
  }

  Future deleteStory() async {
    return await story.doc(sid).delete(
    );
  }


  // UserData from snapshot
  StoryData _story(DocumentSnapshot snapshot) {
    return StoryData(
        storyid: sid,
        acctype: snapshot.data()['acctype'],
        datecreate: snapshot.data()['datecreate'],
        name: snapshot.data()['name'],
        descri: snapshot.data()['descri'],
        img: snapshot.data()['img'],
        tcomment: snapshot.data()['tcomment'],
        title: snapshot.data()['title'],
        tlike: snapshot.data()['tlike'],
        totlike : snapshot.data()['totllike'],
        ufacebook: snapshot.data()['ufacebook'],
        userid : snapshot.data()['userid'],
        uyoutube: snapshot.data()['uyoutube'],

    );

  }






  //Stream


  // get user data stream
  Stream<StoryData> get storyData {
    return story.doc(sid).snapshots().map(_story);
  }
}
