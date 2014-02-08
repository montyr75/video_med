library playlist;

import "media.dart";

class Playlist {
  String id;
  String title;
  String description;
  List<Media> media = [];

  Iterator iterator;

  Playlist();

  Playlist.fromMap(Map map) {
    id = map["id"];
    title = map["title"];
    description = map["description"];
    map["media"].forEach((Map mediaMap) => media.add(new Media.fromMap(mediaMap)));

    reset();
  }

  bool reset() {
    if (media.isNotEmpty) {
      iterator = media.iterator;
      return true;
    }

    return false;
  }

  Media next() {
    // return next media element, if there is one
    if (iterator != null && iterator.moveNext()) {
      return iterator.current;
    }

    // loop back to the beginning of the list, or return null if no list
    return reset() ? next() : null;
  }

  Map toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "media": media.map((Media media) => media.toMap())
    };
  }

  @override String toString() => "$id: $title :: $media";
}