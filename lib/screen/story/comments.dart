import 'dart:developer';

import 'package:app/models/UserMod.dart';
import 'package:app/services/StoryService.dart';
import 'package:app/services/commentservice.dart';
import 'package:app/services/userdb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
class CommentPage extends StatefulWidget {

  final String storyid;

  const CommentPage({Key key, this.storyid}) : super(key: key);


  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {


   var _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserM>(context);
    CollectionReference comm = FirebaseFirestore.instance.collection('comments');
    CollectionReference story = FirebaseFirestore.instance.collection('storys');

    var nsid = Uuid().v4();




    return Scaffold(
appBar: AppBar(
  title: Text('Comments'),
  backgroundColor: Colors.pinkAccent,
  centerTitle: true,
),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('to', isEqualTo: widget.storyid)
            .snapshots(),
        builder: (context, snapshot) {


          return ListView(




            children : [


              ListView.builder(

                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot?.data?.documents?.length ?? 0,
                itemBuilder: (context, index) {

                  DocumentSnapshot _data = snapshot.data.documents[index];


                  return Card(


                    child: ListTile(
                      leading: CircleAvatar(child : Image.network(_data['profilepic'])),
                      title: Text(_data['from']),
                      subtitle: Text(_data['content']),
                      trailing: Text(_data['time']),

                    ),




                  );
                },
              ),
              Container(

                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _comment,



                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: DatabaseService(uid: user.uid ).userData,
                        builder: (context, snapshot) {

                          UserData _data = snapshot.data;

                          return StreamBuilder(
                            stream: story.doc(widget.storyid).snapshots(),
                            builder: (context, snapshot) {

                              log(DateGetter());

                              return IconButton(onPressed: () async{

                                await CommentService(cid: nsid).updateComments(
                                    _comment.text,
                                    _data.name,
                                    _data.profilepic,
                                    DateGetter(),
                                     widget.storyid,
                                      user.uid);


                                    int _tcomment = snapshot.data['tcomment'];
                                    _tcomment++;
                                    log(_tcomment.toString());
                               await StoryService(sid: widget.storyid).updateUserPoint(_tcomment);



                                },


                                icon: Icon(Icons.comment),


                              );
                            }
                          );
                        }
                    ),
                  ],
                ),
              )
            ]
          );





        }
      ),

    );

  }
   DateGetter(){
     DateTime now = DateTime.now();
     String formattedDate = DateFormat('MM/dd/yyyy  HH:mm:ss').format(now);
     return formattedDate;
   }

}
