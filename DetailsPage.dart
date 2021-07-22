import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Details extends StatefulWidget {

  final String id;
  const Details({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  late WebViewController _controller;
  late String url = "https://www.paramountplus.com/intl/";
  bool loader = true;

  @override
  void initState() {
    // TODO: implement initState
    WebView.platform = SurfaceAndroidWebView();
    http.get(
        Uri.parse("https://api.themoviedb.org/3/movie/${widget.id}?api_key=55957fcf3ba81b137f8fc01ac5a31fb5")
    ).then((response) {
      print(response.body);
      url = jsonDecode(response.body)["homepage"];
    }).then((value) {
      _controller.loadUrl(url).then((value){
        Future.delayed(Duration(milliseconds: 1000)).then((value) {
          setState(() {loader = false;});
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
            children:[
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: url,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
              ),
              loader ? Container(color: Colors.black,child: Center(child: CircularProgressIndicator(backgroundColor: Colors.deepOrange, color: Colors.white, strokeWidth: 10,),)) : Container()
            ]
        ),
      ),
    );
  }
}
