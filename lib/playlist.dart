library playlist;

import "media.dart";

class Playlist {
  String id;
  String title;
  String description;
  List<Media> media = [];     // this only needs to be filled out for clients
  List<String> mediaNames;

  Iterator iterator;

  Playlist();

  Playlist.fromDBMap(Map map) {
    _fromMap(map);
    mediaNames = map["mediaNames"];
  }

  Playlist.fromMessageMap(Map map) {
    _fromMap(map);
    map["media"].forEach((Map mediaMap) => media.add(new Media.fromMap(mediaMap)));

    reset();
  }

  void _fromMap(Map map) {
    id = map["id"];
    title = map["title"];
    description = map["description"];
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

  Map _toMap() {
    return {
      "id": id,
      "title": title,
      "description": description
    };
  }

  Map toDBMap() {
    Map map = {
      "mediaNames": mediaNames
    };

    map.addAll(_toMap());

    return map;
  }

  Map toMessageMap() {
    Map map = {
      "media": media.map((Media media) => media.toMap()).toList(growable: false)
    };

    map.addAll(_toMap());

    return map;
  }

  @override String toString() => "$id: $title :: $media";
}