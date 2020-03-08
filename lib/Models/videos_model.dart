class VideosModel {
  String chId;
  String vidId;
  String title;
  String description;
  String thumbnailUrl;


  VideosModel(this.chId, this.vidId, this.title, this.description,
      this.thumbnailUrl);

  factory VideosModel.fromJson(Map<String, dynamic> parsedJson){


    var idObject =parsedJson["id"] ;
   // print(idObject);

    var videoId=idObject["videoId"];

   // print("vide Id Is :"+videoId);

   // Map<String, dynamic> snippetObject=parsedJson["snippet"];
   var snippetObject=parsedJson["snippet"];

    //print("snippet is Is Normal:"+snippetObject.toString());
    //print("snippet is Is :${snippetObject}");

    var chIdd=snippetObject["channelId"];

   // print("vide chId Is :"+chIdd);
    var titlee=snippetObject["title"];

   // print("vide title Is :"+titlee);
    var desc=snippetObject["description"];

    //print("vide desc Is :"+desc);


    var thumbObj=snippetObject["thumbnails"];

   // print("Thumb Obj is :"+thumbObj);
    var mediumObj=thumbObj["medium"];
    var thumbUrl=mediumObj["url"];






    return VideosModel(chIdd, videoId, titlee, desc, thumbUrl);
  }
}