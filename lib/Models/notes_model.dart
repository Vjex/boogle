class NotesModel {
  String link;
  String title;
  String description;
  String internal_link;
  String favicon;
  String tags;
  String stamp;

  NotesModel(this.link, this.title, this.description, this.internal_link,
      this.favicon, this.tags, this.stamp);


  factory NotesModel.fromJson(Map<String, dynamic> parsedJson){
    return NotesModel(parsedJson["link"],
      parsedJson["title"],
      parsedJson["description"],
      parsedJson["internal_link"],
      parsedJson["favicon"],
      parsedJson["tags"],
      parsedJson["stamp"]);
  }
}