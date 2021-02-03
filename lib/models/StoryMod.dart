import 'package:flutter/material.dart';

class Story {
  final String sid;


  Story({this.sid});
}

class StoryData {
  final String acctype;
  final String datecreate;
  final String descri;
  final String img;
  final String country;
  final String slug;
  final String name;
  final String title;
  final String userid;
  final String storyid;
  final int tcomment;
  final List tlike;
  final int totlike;
  final String ufacebook;
  final String uyoutube;


  StoryData({
    this.country,
    this.slug,
    this.acctype,
      this.datecreate,
      this.descri,
      this.img,
      this.name,
      this.title,
      this.userid,
      @required this.storyid,
      this.tcomment,
      this.tlike,
      this.totlike,
      this.ufacebook,
      this.uyoutube});

  factory StoryData.fromJson(Map<String, dynamic> json) {
    return StoryData(
      acctype: json['acctype'],
      datecreate: json['datecreate'],
      descri: json['descri'],
      img: json['img'],
      name: json['name'],
      title: json['title'],
      userid: json['userid'],
      storyid: json['storyid'],
      tcomment: json['tcomment'],
      tlike: json['tlike'],
      totlike: json['totlike'],
      ufacebook: json['ufacebook'],
      uyoutube: json['uyoutube'],
      slug: json['slug'],
      country: json['country']

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'acctype': acctype,
      'datecreate': datecreate,
      'descri': descri,
      'img': img,
      'name': name,
      'tcomment': tcomment,
      'title': title,
      'tlike': tlike,
      'ufacebook': ufacebook,
      'uyoutube': uyoutube,
      'userid': userid,
      'totlike': totlike,
      'storyid': storyid,
      'slug':slug,
      'country':country,

    };
  }
}
