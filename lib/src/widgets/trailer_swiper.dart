import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class CargarPelicula extends StatelessWidget {

  final String trailer;  
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  
  CargarPelicula( { @required this.trailer} );

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://youtu.be/${trailer.toString()}',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
    );

  }

}