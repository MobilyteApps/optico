import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewScreen extends StatefulWidget {
  final String url;
  WebViewScreen({Key key, this.url})
      : super(
    key: key,
  );
  @override
  _WebViewScreenState createState() => _WebViewScreenState(url);
}

class _WebViewScreenState extends State<WebViewScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String url= "";
  _WebViewScreenState(this.url);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0076B5),
        leading: GestureDetector(
          onTap: ()  {
            Navigator.of(context)
                .pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: WebView(
        initialUrl: 'http://drive.google.com/viewerng/viewer?embedded=true&url='+url,
//        onWebViewCreated: (WebViewController webViewController) {
//          _controller.complete(webViewController);
//        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
    );
  }
}