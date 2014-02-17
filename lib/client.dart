library client;

class Client {

  // status types
  static const PLAYING = "playing";
  static const PAUSED = "paused";
  static const NO_PLAYLIST = "no playlist";

  String currentPlaylistName;

  String status = NO_PLAYLIST;

  Client([this.currentPlaylistName, this.status]);

  Client.fromDBMap(Map map) : this(map["currentPlaylistName"]);

  Client.fromMessageMap(Map map) : this(map["currentPlaylistName"], map["status"]);

  Map toDBMap() {
    if (currentPlaylistName != null) {
      return {
        "currentPlaylistName": currentPlaylistName
      };
    }

    // if there is no persistable data, there's no need to persist the object
    return null;
  }

  Map toMessageMap() {
    Map map = {
      "status": status
    };

    map.addAll(toDBMap());

    return map;
  }
}