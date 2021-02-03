import 'package:app/models/DonationMod.dart';
import 'package:app/models/StoryMod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/VolunteerProjectMod.dart';
import 'package:app/models/UserMod.dart';

class DonationService {
  final String did;

  DonationService({this.did});

  //collection ref

  final CollectionReference donation =
      FirebaseFirestore.instance.collection('donations');

// Update/Create Data to Collection

  // User Data

  Future updateDonationData(
      String name,
      String datecreate,
      String descri,
      String img,
      String paypalid,
      String projectid,
      String tcatecode,
      String tsecret,
      String ufacebook,
      String userid,
      String uyoutube,
      int curfund,
      String fundneed,
      String psecret,
      String title,
      String acctype,
      String country,
      String token) async {
    return await donation.doc(did).set({
      'name': name,
      'datecreate': datecreate,
      'descri': descri,
      'img': img,
      'paypalid': paypalid,
      'projectid': projectid,
      'curfund': curfund,
      'fundneed': fundneed,
      'tcatecode': tcatecode,
      'tsecret': tsecret,
      'ufacebook': ufacebook,
      'userid': userid,
      'uyoutube': uyoutube,
      'psecret': psecret,
      'title': title,
      'acctype': acctype,
      'country': country,
      'token': token,
    });
  }

  Future updateFund(int fund) async {
    return await donation.doc(did).update({
      'curfund': fund,
    });
  }

  Future deleteFund() async {
    return await donation.doc(did).delete();
  }

  DonationData _donation(DocumentSnapshot snapshot) {
    return DonationData(
        name: snapshot.data()['name'],
        datecreate: snapshot.data()['datecreate'],
        descri: snapshot.data()['descri'],
        img: snapshot.data()['img'],
        paypalid: snapshot.data()['paypalid'],
        projectid: did,
        curfund: snapshot.data()['curfund'],
        fundneed: snapshot.data()['fundneed'],
        tcatecode: snapshot.data()['tcatecode'],
        tsecret: snapshot.data()['tsecret'],
        ufacebook: snapshot.data()['ufacebook'],
        userid: snapshot.data()['userid'],
        uyoutube: snapshot.data()['uyoutube'],
        psecret: snapshot.data()['psecret'],
        title: snapshot.data()['title'],
        acctype: snapshot.data()['acctype'],
        country: snapshot.data()['country'],
        token: snapshot.data()['token']);
  }

  //Stream

  // get user data stream
  Stream<DonationData> get donationData {
    return donation.doc(did).snapshots().map(_donation);
  }
}
