import 'dart:async';
import 'dart:io';
import 'package:compliance/common/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFScreen extends StatefulWidget {
  final String pathPDF;
  PDFScreen({Key key, this.pathPDF})
      : super(
    key: key,
  );

  @override
  PDFScreenState createState() => PDFScreenState(pathPDF);
}
class PDFScreenState extends State<PDFScreen>{
  String pathPDF = "";
  PDFScreenState(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: (){
              Functions().deleteFile(pathPDF).then((_){
                Navigator.pop(context);
              });
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text("Preview"),
          backgroundColor: const Color(0xFF0076B5),
        ),
        path: pathPDF);
  }

}