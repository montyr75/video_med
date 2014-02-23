library media;

import 'package:polymer/polymer.dart';

class Media extends Object with Observable {
  // media types
  static const String IMAGE = "image";
  static const String AUDIO = "audio";
  static const String VIDEO = "video";

  @observable String id;
  @observable String category;
  @observable String type;
  @observable String title;
  @observable String description;
  @observable String filename;
  @observable String runtime;
  @observable String version;
  @observable String language;

  Media();

  Media.fromMap(Map<String, String> map) {
    id = map["id"];
    category = map["category"];
    type = map["type"];
    title = map["title"];
    description = map["description"];
    filename = map["filename"];
    runtime = map["runtime"];
    version = map["version"];
    language = map["language"];
  }

  Map<String, String> toMap() {
    return {
      "id": id,
      "category": category,
      "type": type,
      "title": title,
      "description": description,
      "filename": filename,
      "runtime": runtime,
      "version": version,
      "language": language
    };
  }

  @override String toString() => "$id: $title";
}