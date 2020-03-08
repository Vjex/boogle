import 'dart:convert';

import 'package:boogle/Models/notes_model.dart';
import 'package:boogle/Models/videos_model.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SearchResult extends StatefulWidget {

  String searchString;

  //constructor to get the data from yhe calling class to this class
  SearchResult(this.searchString);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchResultState(this.searchString);
  }

}

class _SearchResultState extends State<SearchResult>{

  String searchString;
  static List<NotesModel> notesModelList = new List<NotesModel>();
  static List<VideosModel> videosModelList = new List<VideosModel>();
  static List<bool> isSelectedListNotes = new List<bool>();
  static List<bool> isSelectedListVideos = new List<bool>();
  Future<List<NotesModel>> notesModelFutures;
  Future<List<VideosModel>> videosModelFutures;

  //ListView Controller
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerVideos = new ScrollController();



  //getting thge String from calling class to this state class
  _SearchResultState(this.searchString);



  @override
  void initState() {
    super.initState();
    // notesModelFutures = getSearchData();

    //select Lists are reinitialized for the new Search only as it stores  or regets the previous state value of the variables autommatically.

    isSelectedListNotes.clear();
    isSelectedListNotes=new List<bool>();

    isSelectedListVideos.clear();
    isSelectedListNotes=new List<bool>();

    print("init State Called!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

   /* Fluttertoast.showToast(
        msg:
        searchString+"Called",
        toastLength: Toast.LENGTH_SHORT);*/

    //getSearchData();

    return callScreen();
  }

  Widget callScreen() {

    return   DefaultTabController(
        length: 2,
        child:Scaffold(
          appBar: AppBar(
            title: Text("Search Result"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.book),
                  text: "Notes",
                ),
                Tab(icon: Icon(Icons.video_label),
                  text: "Videos",
                ),
              ],
            ),

            //back button
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //pop the class for back
                  Navigator.of(context).pop(true);
                }),
          ),

          //Body of Scafflod
          body: TabBarView(
            children: [
              getNotes(),
              getVideos(),
            ],
          ),

        )
    );
  }

  Widget getNotes() {

    return FutureBuilder<List<NotesModel>>(
      future: getSearchData(),
      builder: (context, snapshot){

        if(snapshot.hasData){

         // notesModelList.clear();
         // notesModelList=new List<NotesModel>();
          notesModelList=snapshot.data;
        //  isSelectedListNotes.clear();
        //  isSelectedListNotes=
          for(int i=0;i<notesModelList.length;i++){
            isSelectedListNotes.add(false);
          }
         // print("data Got Now !!!!!!!!!!!!!!!!!!!!!Show List");
          return getFinalNotesListViewWidget();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );

  }

  Widget getVideos() {

    //print("Ne wSerch Videos Called!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

    return FutureBuilder<List<VideosModel>>(
      future: getSearchVideosData(),
      builder: (context, snapshot){

        if(snapshot.hasData){

          // notesModelList.clear();
          // notesModelList=new List<NotesModel>();
          videosModelList=snapshot.data;
          //  isSelectedListNotes.clear();
          //  isSelectedListNotes=
          for(int i=0;i<videosModelList.length;i++){
            isSelectedListVideos.add(false);
          }
         // print("data Got Now !!!!!!!!!!!!!!!!!!!!!Show ListVideos");
          return getFinalNotesListViewWidgetVideos();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }

  Future<List<NotesModel>> getSearchData() async {
    try {
     // print("called Data code!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      var callString="https://bogle.herokuapp.com/search/${searchString}";
      print(callString);
      final response = await http.get(callString);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
       // print('Items: ${notesModelList.length}');
        return jsonResponse.map((notes) => new NotesModel.fromJson(notes)).toList();
        // notesModelList = jsonResponse.map((job) => new NotesModel.fromJson(job)).toList();;
        print('Items: ${notesModelList.length}');
        /*setState(() {
          loading = false;
        });*/
      } else {
        print("Error getting users Ye valla.Notes");
      }
    } catch (e) {
      print("Error getting users Notes!!!.    "+e.toString());
    }
  }

  Future<List<VideosModel>> getSearchVideosData() async {
    try {

      final String videoSearchString= searchString.replaceAll(RegExp(' '), '+');
   //   print("called Data Videos code!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      var callString="https://www.googleapis.com/youtube/v3/search?part=snippet&id&q=${videoSearchString}&type=video&maxResults=50&key=AIzaSyDwRkyMI1UY6tt_zVWbflB7xR-mhPE7-rw";

      print(callString);
    //  print(searchString);

      final response = await http.get(callString);
      if (response.statusCode == 200) {
        var jsonResponseYouTube = json.decode(response.body);
        var list=jsonResponseYouTube['items'] as List ;

       // print('Items: ${list.length}');
      //  print('Items List !!!!!: ${list}');

        return list.map((videos) => new VideosModel.fromJson(videos)).toList();
        // notesModelList = jsonResponse.map((job) => new NotesModel.fromJson(job)).toList();;
        print('Items: ${notesModelList.length}');
        /*setState(() {
          loading = false;
        });*/
      } else {
        print("Error getting users Ye valla Videos.");
      }
    } catch (e) {
      print("Error getting users Videos!!!!!!.    "+e.toString());
    }
  }

  /*static List<NotesModel> loadEachNoteDetail(String body) {
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return parsed.map((json) => new NotesModel.fromJson(json)).toList();
  }*/

  Widget getFinalNotesListViewWidget() {

  //  print("List Widget Called!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    return ListView.builder(
      itemCount: notesModelList.length,
      itemBuilder: (BuildContext context, int index){

        return  row(notesModelList[index],index);
      },
      controller: _scrollController,

    );

  }

  Widget getFinalNotesListViewWidgetVideos() {

   // print("List Widget Called Videos!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    return ListView.builder(
      itemCount: videosModelList.length,
      itemBuilder: (BuildContext context, int index){

        return  rowVideos(videosModelList[index],index);
      },
      controller: _scrollControllerVideos,

    );

  }

  ListTile row(NotesModel notesModelList, int index) {


   // print("called Print Roww!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
   /* setState(() {

    });*/

    var title=notesModelList.title;
    var description=notesModelList.description;
   // isSelectedListNotes[index]=false;

    return ListTile(
      title: Text(title.length > 70 ? '${title.substring(0, 70)}...' : title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isSelectedListNotes[index] && isSelectedListNotes.length>=index  ? Colors.purple : Colors.blue,
          ),
      maxLines: 2,),
      subtitle: Text(description.length > 200 ? '${description.substring(0, 200)}...' : description,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[400],
        ),
        maxLines: 4,

      ),
      leading: Container(
        width: 30,
        height: 30,
        child:Image.network("https://"+notesModelList.favicon),
      ),
      onTap: () {
        setState(() {

          isSelectedListNotes[index]=true;
          _launchURL(notesModelList.link);
        });
      },
    );
  }


  ListTile rowVideos(VideosModel videosModelList, int index) {


    // print("called Print Roww!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    /* setState(() {

    });*/

    var title=videosModelList.title;
    var description=videosModelList.description;
    // isSelectedListNotes[index]=false;

    return ListTile(
      title: Text(title.length > 70 ? '${title.substring(0, 70)}...' : title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isSelectedListVideos[index] && isSelectedListVideos.length>=index  ? Colors.purple : Colors.blue,
        ),
        maxLines: 2,),
      subtitle: Text(description.length > 200 ? '${description.substring(0, 200)}...' : description,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[400],
        ),
        maxLines: 4,

      ),
      leading: Container(
        width: 60,
        height: 60,
        child:Image.network(videosModelList.thumbnailUrl),
        ),
      onTap: () {
        setState(() {

          isSelectedListVideos[index]=true;
          _launchURL("https://www.youtube.com/watch?v=${videosModelList.vidId}");
        });
      },
    );
  }

  _launchURL(String link) async {
    ;
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }
}