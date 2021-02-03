
import 'package:app/screen/event/vevent.dart';
import 'package:app/template/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapTest extends StatefulWidget {
  @override
  State<MapTest> createState() => MapTestState();
}

class MapTestState extends State<MapTest> {
 GoogleMapController _controller ;
  Map<MarkerId,Marker> markers = <MarkerId,Marker>{};

  static final CameraPosition initCoord = CameraPosition(
    target: LatLng(3.122500, 101.653038),
    zoom: 14.4746,
  );


  void initMarker(specify,specifyId) async {
        var markerIdVal = specifyId;
        final MarkerId  markerId = MarkerId(markerIdVal);
        final marker = Marker(
          markerId: markerId,
          position: LatLng( specify['location'].latitude,specify['location'].longitude),
          infoWindow: InfoWindow(title: specify['title'],snippet: specify['descri']),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VEvent(projectid: specifyId),
              ),
            );
          },

        );

        setState(() {
          markers[markerId] = marker;
        });
  }

 getMarkerData() async {

   CollectionReference projects = FirebaseFirestore.instance.collection('vprojects');

   await FirebaseFirestore.instance.collection('vprojects').where('status',isEqualTo: 'complete')
       .get().then((mydata) {
     if(mydata.docs.isNotEmpty){

       print(mydata.docs.toList().toString());


       for(int i = 0 ; i < mydata.docs.length ; i++){
         initMarker(mydata.docs[i].data(), mydata.docs[i].id );

       }
     }else if(mydata.docs.isEmpty){


       return  Loading();
     }
   });

 }


void initState(){
    getMarkerData();
    super.initState();
}
    

  @override
  Widget build(BuildContext context) {




    Set<Marker> getMarker(){
     return <Marker>{

       Marker(
         markerId: MarkerId("UM"),
         position: LatLng(3.122500, 101.653038),
         icon: BitmapDescriptor.defaultMarker,
         infoWindow: InfoWindow(title: 'University of Malaya'),

       )
     };



    }
    return  SafeArea(
      child: Scaffold(


        appBar: AppBar(
          title: const Text('Map Of Completed Projects'),
          backgroundColor: Colors.pinkAccent,
        ),


        body:

        Card(
            child:
            GoogleMap(
          markers: Set<Marker>.of(markers.values),
          mapType: MapType.hybrid,
          initialCameraPosition: initCoord,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
        ),






        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: Text('test'),
        //   icon: Icon(Icons.directions_car),
        // ),
      ),
    );
  }


}