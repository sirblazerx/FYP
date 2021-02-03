import 'package:app/models/DonationMod.dart';
import 'package:app/models/StoryMod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/VolunteerProjectMod.dart';
import 'package:app/models/UserMod.dart';

class VolunteerService {
  final String vpid;


  VolunteerService({this.vpid});

  //collection ref

  final CollectionReference vproject =
  FirebaseFirestore.instance.collection('vprojects');


// Update/Create Data to Collection

  // User Data

  // Future updateDonationData(String name, String datecreate, String descri,
  //     String img, String paypalid, String projectid,String tcatecode,String tsecret,String ufacebook,String userid,String uyoutube , int curfund , String fundneed,String psecret,String title,String acctype,String country) async {
  //   return await vproject.doc(vpid).set({
  //
  //
  //     'name': name,
  //     'datecreate': datecreate,
  //     'descri': descri,
  //     'img': img,
  //     'paypalid': paypalid,
  //     'projectid': projectid,
  //     'curfund' : curfund,
  //     'fundneed' : fundneed,
  //     'tcatecode' : tcatecode,
  //     'tsecret' : tsecret,
  //     'ufacebook' : ufacebook,
  //     'userid' : userid,
  //     'uyoutube' : uyoutube,
  //     'psecret' : psecret,
  //     'title' : title,
  //     'acctype' : acctype,
  //     'country' : country,
  //
  //
  //
  //
  //
  //   });
  // }


  // Future updateFund(int fund) async {
  //   return await vproject.doc(vpid).update({
  //
  //     'curfund' : fund,
  //
  //
  //   });
  // }
  //
  // Future deleteFund() async {
  //   return await vproject.doc(vpid).delete(
  //
  //
  //
  //
  //   );
  // }



  ProjectData _project (DocumentSnapshot snapshot) {
    return ProjectData(
      name: snapshot.data()['name'],
      datecreate: snapshot.data()['datecreate'],
      descri:snapshot.data()['descri'],
      img: snapshot.data()['img'],
      projectid: vpid,
      ufacebook: snapshot.data()['ufacebook'],
      userid: snapshot.data()['userid'],
      uyoutube: snapshot.data()['uyoutube'],
      title: snapshot.data()['title'],
      acctype: snapshot.data()['acctype'],
      country: snapshot.data()['country'],
      dateproject: snapshot.data()['dateproject'],
      listvon: snapshot.data()['listvon'],
      location: snapshot.data()['location'],
      locationame: snapshot.data()['locationname'],
        status: snapshot.data()['status'],







    );

  }






  //Stream


  // get user data stream
  Stream<ProjectData> get donationData {
    return vproject.doc(vpid).snapshots().map(_project);
  }
}
