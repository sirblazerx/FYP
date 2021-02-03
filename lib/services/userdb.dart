
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserMod.dart';

class DatabaseService {
  final String uid;


  DatabaseService({ this.uid});

  //collection ref

  final CollectionReference user =
      FirebaseFirestore.instance.collection('users');


// Update/Create Data to Collection

  // User Data

  Future updateUserData(String name, String acctype, String contact,
      String address, String country, String profilepic,int TVol,int TDon,int point,int nnotification,String fbpage , String officialweb,int tprojectjoin,String userid,String sex) async {
    return await user.doc(uid).set({

      'name': name,
      'acctype': acctype,
      'contact': contact,
      'address': address,
      'country': country,
      'profilepic': profilepic,
      'TVol' : TVol,
      'TDon' : TDon,
      'point' : point,
      'nnotification' : nnotification,
      'fbpage' : fbpage,
      'officialweb' : officialweb,
      'tprojectjoin' : tprojectjoin,
      'userid' : userid,
      'sex' : sex,



    });
  }


  Future updateUserPoint(int point) async {
    return await user.doc(uid).update({

      'point' : point,


    });
  }

  Future updateProjectJoined(int point) async {
    return await user.doc(uid).update({

      'tprojectjoin' : point,


    });
  }

  Future updateProfilePic(String profilepic) async {
    return await user.doc(uid).update({

      'profilepic': profilepic,


    });
  }


  // UserData from snapshot
  UserData _profile(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        acctype: snapshot.data()['acctype'],
        address: snapshot.data()['address'],
        name: snapshot.data()['name'],
        contact: snapshot.data()['contact'],
        country: snapshot.data()['country'],
        profilepic: snapshot.data()['profilepic'],
        fbpage: snapshot.data()['fbpage'],
        officialweb: snapshot.data()['offcialweb'],
        TVol : snapshot.data()['TVol'],
        TDon: snapshot.data()['TDon'],
        point : snapshot.data()['point'],
        tprojectjoin: snapshot.data()['tprojectjoin'],
        nnotification : snapshot.data()['nnotification'],
        sex: snapshot.data()['sex'],
        );

  }






  //Stream


  // get user data stream
  Stream<UserData> get userData {
    return user.doc(uid).snapshots().map(_profile);
  }
}
