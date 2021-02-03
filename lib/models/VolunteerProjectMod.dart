import 'package:cloud_firestore/cloud_firestore.dart';

class Volunteer {
  final String projectid;

  Volunteer({this.projectid});
}

class ProjectData {
  final String projectid;
  final String acctype;
  final String datecreate;
  final String descri;
  final String country;
  final DateTime dateproject;
  final GeoPoint location;
  final String img;
  final String listvon;
  final String name;
  final String status;
  final String title;
  final String userid;
  final String uyoutube;
  final String ufacebook;
  final String locationame;

  ProjectData({this.projectid, this.acctype, this.datecreate, this.descri, this.country, this.dateproject, this.location, this.img, this.listvon, this.name, this.status, this.title, this.userid, this.uyoutube, this.ufacebook, this.locationame});


}
