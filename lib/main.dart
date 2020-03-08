import 'package:boogle/SearchResult.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:animated_splash/animated_splash.dart';


void main() {

  /*Function duringSplash = () {
    print('Something background process');
    int a = 123 + 23;
    print(a);

    if (a > 100)
      return 1;
    else
      return 2;
  };

  Map<int, Widget> op = {1: MyApp(),2: MyApp()};*/

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnimatedSplash(
      imagePath: 'images/logo_image.png',
      home: MyApp(),
      //customFunction: duringSplash,
      duration: 2500,
     // type: AnimatedSplashType.BackgroundProcess,
      type: AnimatedSplashType.StaticDuration,
      //outputAndHome: op,
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boogle',
      //This is for not showing the debug banner on the app.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Boogle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  TextEditingController controllerSearchText = TextEditingController();
  bool _validate = true;
  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String hintSearch="search here";
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onError: errorListener, onStatus: statusListener );

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      /*appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/
      body: Container(
        margin: EdgeInsets.all(10.0),
        child:Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo_image.png',
                   width: 260.0,
                   height: 140.0,
                 // fit: BoxFit.cover,
                ),
            Container(
              margin: EdgeInsets.all(15.0),
                child: new RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    children: <TextSpan>[
                      new TextSpan(text: 'B',style: TextStyle(fontSize: 49.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen,)),
                      new TextSpan(text: 'o', style:  TextStyle(fontSize: 49.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,)),
                      new TextSpan(text: 'o', style:  TextStyle(fontSize: 49.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,)),
                      new TextSpan(text: 'G', style:  TextStyle(fontSize: 49.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[200],)),
                      new TextSpan(text: 'L', style:  TextStyle(fontSize: 49.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[300],)),
                      new TextSpan(text: 'e', style:  TextStyle(fontSize: 49.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen,)),
                    ],
                  ),
            ),
            ),
                showTextField("Search", "Search Notes"),
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: SizedBox(  //size Box to define size
                    width: double.infinity, //match parent
                    child: RaisedButton(
                    color: Colors.green[700],
                    textColor: Colors.white,
                    colorBrightness: Brightness.light,
                    onPressed: () {
                      setState(() {

                        if(controllerSearchText.text.isEmpty){
                          _validate = false;
                        }else{
                          _validate = true;
                          goToResultPage();
                        }

                        // getCompany();
                       /* Fluttertoast.showToast(
                            msg:
                            'Clicked!',
                            toastLength: Toast.LENGTH_LONG);*/

                      });
                    },
                    child: Text("Search",maxLines: 1,
                      style: new TextStyle(
                      fontSize: 14.0,
                      //color: Colors.yellow,
                    ),),
                    elevation: 11,
                    highlightElevation: 2,
                    textTheme: ButtonTextTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.all(20.0),
                  ),
                  ),
                ),
              ],
            ),
          )
      ),
      )
    );
  }


  Widget showTextField(String labelM, String hintM) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextField(
        controller: controllerSearchText,
        onSubmitted: (value) {
          setState(() {

          });
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => startListening(),
            icon: Image.asset('images/speech_icon.png',),
          ),
          labelText: labelM,
          hintText: hintSearch,
          errorText: _validate ? null : 'Value Can\'t Be Empty',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  void goToResultPage() {

    String searchText=controllerSearchText.text;

   /* if(searchText == null || searchText == " "){
    }*/

    Navigator.push(context,
        MaterialPageRoute(builder: (context) {

          //SearchResult is constructor of the class wher to send the searchText For getting search result.
          return SearchResult(
              searchText);
        }));
  }


  void startListening() {

    hintSearch="Please say something...";
    //controllerSearchText.text="";
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener );
    setState(() {

    });
  }

  void stopListening() {
    speech.stop( );
    setState(() {

    });
  }

  void cancelListening() {
   // controllerSearchText.text=lastWords;
    speech.cancel( );
    setState(() {

    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
      controllerSearchText.text=result.recognizedWords;
     // print("This is result: "+ result.toString());
     // print("This is Text: "+controllerSearchText.text);
      hintSearch="search here";
    });
  }

  void errorListener(SpeechRecognitionError error ) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }
  void statusListener(String status ) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
