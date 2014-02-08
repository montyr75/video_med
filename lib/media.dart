library media;

class Media {
  // media types
  static const String IMAGE = "image";
  static const String AUDIO = "audio";
  static const String VIDEO = "video";

  String id;
  String category;
  String type;
  String title;
  String description;
  String filename;
  String runtime;

  Media();

  Media.fromMap(Map<String, String> map) {
    id = map["id"];
    category = map["category"];
    type = map["type"];
    title = map["title"];
    description = map["description"];
    filename = map["filename"];
    runtime = map["runtime"];
  }

  Map<String, String> toMap() {
    return {
      "id": id,
      "category": category,
      "type": type,
      "title": title,
      "description": description,
      "filename": filename,
      "runtime": runtime
    };
  }

  @override String toString() => "$id: $title";
}