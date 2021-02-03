import 'package:app/models/commentsMod.dart';
import 'package:app/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final String tid;

  TransactionService({this.tid});

  //collection ref

  final CollectionReference trans =
      FirebaseFirestore.instance.collection('transcations');

// Update/Create Data to Collection

  // User Data

  Future updateTrans(
      String donatorid,
      String donatorname,
      String platform,
      String projectid,
      String projectname,
      String recieverid,
      String status,
      String time,
      int total,
      String transid) async {
    return await trans.doc(tid).set({
      'donatorid': donatorid,
      'donatorname': donatorname,
      'platform': platform,
      'projectid': projectid,
      'projectname': projectname,
      'receieverid': recieverid,
      'status': status,
      'time': time,
      'total': total,
      'transid': transid,
    });
  }

  TData _trans(DocumentSnapshot snapshot) {
    return TData(
      donatorid: snapshot.data()['donatorid'],
      donatorname: snapshot.data()['donatorname'],
      platfom: snapshot.data()['platform'],
      projectid: snapshot.data()['projectid'],
      projectname: snapshot.data()['projectname'],
      receiverid: snapshot.data()['recieverid'],
      status: snapshot.data()['status'],
      time: snapshot.data()['time'],
      total: snapshot.data()['total'],
      transid: snapshot.data()['transid'],
    );
  }

  //Stream

  // get user data stream
  Stream<TData> get userData {
    return trans.doc(tid).snapshots().map(_trans);
  }
}
