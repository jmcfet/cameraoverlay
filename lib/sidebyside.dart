
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
class sidebyside extends StatelessWidget {
  sidebyside( this.fileLeft, this.fileRight);

  File fileLeft;
  File fileRight;



  @override
  Widget build(BuildContext context) {
    var title = ' Images';
    double width =  MediaQuery
        .of(context)
        .size
        .width ;
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    return MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body:
          Row(


              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  width: width /2,
                  child: Image.file(fileLeft,
                    fit: BoxFit.fill,
                  ),

                ),

                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  width: width /2,
                  child: Image.file(fileRight,
                      fit: BoxFit.fill,
                  ),
                ),


              ]

          ),

        )
    );
  }
}
