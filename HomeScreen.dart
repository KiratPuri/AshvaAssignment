import 'dart:convert';
import 'package:assignment/DetailsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'main.dart';

class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {

  List<String> title = [], vote_average = [], vote_count =[], release_date =[], poster_path =[], id =[];
  ScrollController bigController = ScrollController();
  late List<ScrollController> littleController;

  @override
  void initState() {
    // TODO: implement initState
    http.get(Uri.parse("https://api.themoviedb.org/3/movie/now_playing?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=undefined")).then((response) {
      print(response.body);
      jsonDecode(response.body)["results"].forEach((map){
        title.add(map["title"]);
        vote_average.add(map["vote_average"].toString());
        vote_count.add(map["vote_count"].toString());
        release_date.add(map["release_date"].toString());
        poster_path.add(map["poster_path"]);
        id.add(map["id"].toString());
      });
      print(id);
    }).then((value) {
      littleController = List.filled(id.length, ScrollController());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0xff810a3b10)));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backwardsCompatibility: false,
          backgroundColor: Colors.black,
          title: Text("Mudra", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          controller: bigController,
          children: List.generate(id.length, (index){
            return  GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Details(id: id[index]);}));
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: width/411 * width,
                      height: 200/411 * width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.network("https://image.tmdb.org/t/p/w780/${poster_path[index]}",
                          fit: BoxFit.fitWidth,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return Image.asset("assets/avatar.png",
                              height: 137/411 * width,
                              width:  234/411 * width,
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: width/411 * width,
                      height: 100/411 * width,
                      color: Colors.black54,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0/411 * width),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Title - " + title[index], style: TextStyle(color: Colors.white, fontSize: 18/411 * width, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis,),
                            Text("Vote Average - " + vote_average[index], style: TextStyle(color: Colors.white, fontSize: 15/411 * width, fontWeight: FontWeight.w400)),
                            Text("Vote Count - " + vote_count[index], style: TextStyle(color: Colors.white, fontSize: 15/411 * width, fontWeight: FontWeight.w400)),
                            Text("Release Date - " + release_date[index], style: TextStyle(color: Colors.white, fontSize: 15/411 * width, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ],
              ),
            );
          }),
        )
      ),
    );
  }
}
