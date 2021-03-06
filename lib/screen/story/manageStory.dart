
import 'package:app/models/UserMod.dart';
import 'package:app/screen/story/VStoryEdit.dart';
import 'package:app/screen/story/createStory.dart';
import 'package:app/template/CustomListTileStory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class ManageStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserM>(context);

    return Scaffold(
      appBar:
      AppBar(
        title: Text('My Story Screen'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0.0,
      ),

      body: StreamBuilder(
        stream:
        FirebaseFirestore.instance
            .collection("storys")
            .where('userid', isEqualTo: user.uid)
            .orderBy('datecreate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.data == null) return Text('null');


          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemExtent: 106.0,
            itemCount: snapshot?.data?.documents?.length ?? 0,
            itemBuilder: (context, index) {

              DocumentSnapshot _data = snapshot.data.documents[index];



              // Declaration of FB,YT vids



              Widget mediaGetter(){

                if(_data['img'] != null ){
                  return Image.network(_data['img']);
                }
                else if (_data['uyoutube'] != null){
                  String vid;

                  // Convert Video to ID
                  vid = YoutubePlayer.convertUrlToId(_data['uyoutube']) ;

                  var _controller = YoutubePlayerController(

                    initialVideoId: vid ,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: true,
                    ),
                  );

                  return YoutubePlayer(controller: _controller,
                    showVideoProgressIndicator: true,);
                }
                else if (_data['ufacebook'] != null){

                  InAppWebViewController webView;
                  var url = _data['ufacebook'];

                  return InAppWebView(

                    initialUrl: url,
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                          preferredContentMode: UserPreferredContentMode.DESKTOP),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {

                    },
                    onLoadStop: (InAppWebViewController controller, String url) async {

                    },


                  );

                }


                else {
                  return Icon(Icons.person);
                }

              }
              // Get Video URL


              return Card(


                child: InkWell(

                  onTap:() {

                Navigator.push(

                    context,

                  MaterialPageRoute(builder: (context) => VStoryEdit(storyid : _data.id ,),

                ));
              },
                  child: CustomListTile(

                    // onTap: () {
                    //    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditStory(storyid : snapshot.data.documents[index])));},

                    user: _data['name'],
                    description: _data['descri'],
                    thumbnail: Container(
                      decoration: const BoxDecoration(color: Colors.transparent),
                      child :
                      mediaGetter()
                      ,

                    ),
                    title: _data['title'],
                  ),
                ),



              );
            },
          );
        },
      ),

      floatingActionButton:  FloatingActionButton(
        onPressed: (){

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStory()),
          );
        },
        child:
        Icon(Icons.add)  ,),
      );





  }
}
