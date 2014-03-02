library admin_model;

import 'package:polymer/polymer.dart';
import 'package:VideoMed/media.dart';
import 'package:VideoMed/playlist.dart';

class Model extends Object with Observable {

  // db collections
  @observable List<Media> media = toObservable([]);              // all available media
  @observable List<Playlist> playlists = toObservable([]);       // all created playlists

  @observable Map<String, String> _clientPlaylists = toObservable({});  // client playlist assignments
  @observable List<String> categories = toObservable(["All"]);       // all media categories

  Model();

  Model.fromServerMap(Map map) {
    // decode and objectify media
    Map mediaMaps = map["media"] != null ? map["media"] : {};
    mediaMaps.forEach((String key, Map value) => media.add(new Media.fromMap(value)));

    // decode and objectify playlists
    Map playlistsMap = map["playlists"] != null ? map["playlists"] : {};
    playlistsMap.forEach((String key, Map value) => playlists.add(new Playlist.fromDBMap(value)));

    // decode client playlist assignments
    _clientPlaylists = map["clientPlaylists"] != null ? map["clientPlaylists"] : {};

    // get list of categories from Media objects
    media.forEach((Media item) {
      if (!categories.contains(item.category)) {
        categories.add(item.category);
      }
    });
  }
}
