import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(top: 100.0, bottom: 10.0),
            child: Center(
                child: Text(
              'News Wizard',
              style: TextStyle(fontSize: 50.0),
            ))),
        Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: Center(
                child: Text(
              'Stay tuned for all the trending news around the globe',
              style: TextStyle(fontSize: 15.0),
            ))),
        Image.asset('images/news_wizard_darkmode.png'),
        Spacer(),
        Container(
            margin: const EdgeInsets.only(top: 100.0, bottom: 10.0),
            child: Text(
              'Write to us at scarlettspeedster@gmail.com',
              style: TextStyle(fontSize: 15.0),
            )),
        Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Center(
                child: Text(
              'Current Version : 1.0.1 Beta',
              style: TextStyle(fontSize: 13.0),
            ))),
      ],
    ));
  }
}
