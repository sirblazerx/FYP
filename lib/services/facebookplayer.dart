import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';




class FVid extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var html = '''
           <iframe src="https://www.facebook.com/video/embed?video_id=349371132825150" allow="accelerometer; autoplay; clipboard-write; encrypted-media" allowfullscreen > </iframe>
     ''';

    return  MaterialApp(
      home:  Scaffold(
        appBar: AppBar(
          title:  Text('Plugin example app'),
        ),
        body:  Column(
          children: [
            AspectRatio(
              aspectRatio: 3/2,
              child: Container(
                child: HtmlWidget(
                  html,
                  webView: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}