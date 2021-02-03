import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

SpeedDial buildSpeedDial() {
  return SpeedDial(
    animatedIcon: AnimatedIcons.menu_close,
    animatedIconTheme: IconThemeData(size: 22.0),
    // child: Icon(Icons.add),
    onOpen: () => print('OPENING DIAL'),
    onClose: () => print('DIAL CLOSED'),

    curve: Curves.bounceIn,
    children: [
      SpeedDialChild(
        child: Icon(Icons.accessibility, color: Colors.white),
        backgroundColor: Colors.deepOrange,
        onTap: () => print('FIRST CHILD'),
        label: 'First Child',
        labelStyle: TextStyle(fontWeight: FontWeight.w500),
        labelBackgroundColor: Colors.deepOrangeAccent,
      ),
      SpeedDialChild(
        child: Icon(Icons.brush, color: Colors.white),
        backgroundColor: Colors.green,
        onTap: () => print('SECOND CHILD'),
        label: 'Second Child',
        labelStyle: TextStyle(fontWeight: FontWeight.w500),
        labelBackgroundColor: Colors.green,
      ),
      SpeedDialChild(
        child: Icon(Icons.keyboard_voice, color: Colors.white),
        backgroundColor: Colors.blue,
        onTap: () => print('THIRD CHILD'),
        labelWidget: Container(
          color: Colors.blue,
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(6),
          child: Text('Custom Label Widget'),
        ),
      ),
    ],
  );
}
