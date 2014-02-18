library server_model;

import 'dart:io';
import 'dart:convert';

import 'package:VideoMed/media.dart';
import 'package:VideoMed/playlist.dart';

class Model {

  // db files paths
  static const MEDIA_FILE_PATH = "data/media.json";
  static const PLAYLISTS_FILE_PATH = "data/playlists.json";
  static const CLIENT_PLAYLISTS_FILE_PATH = "data/client_playlists.json";

  // db files
  File mediaFile = new File(MEDIA_FILE_PATH);
  File playlistsFile = new File(PLAYLISTS_FILE_PATH);
  File clientPlaylistsFile = new File(CLIENT_PLAYLISTS_FILE_PATH);

  // db collections
  Map<String, Media> media = {};              // all available media
  Map<String, Playlist> playlists = {};       // all created playlists

  Map<String, String> _clientPlaylists = {};  // client playlist assignments

  Model() {
    print("Model()");

    loadAll();
  }

  void loadAll() {
    loadMediaFile();
    loadPlaylistsFile();
  }

  void saveAll() {
    saveMediaFile();
    savePlaylistsFile();
  }

  void loadMediaFile() {
    // load and decode
    Map maps = mediaFile.existsSync() ? JSON.decode(mediaFile.readAsStringSync()) : {};

    // create objects
    maps.forEach((String key, Map value) => media[key] = new Media.fromMap(value));
  }

  void saveMediaFile() {
    // create Media maps
    Map maps = {};
    media.forEach((String key, Media value) => maps[key] = value.toMap());

    // create or overwrite file with current data
    mediaFile.writeAsStringSync(JSON.encode(maps));
  }

  void loadPlaylistsFile() {
    // load and decode
    Map maps = playlistsFile.existsSync() ? JSON.decode(playlistsFile.readAsStringSync()) : {};

    // create objects
    maps.forEach((String key, Map value) => playlists[key] = new Playlist.fromDBMap(value));
  }

  void savePlaylistsFile() {
    // create Media maps
    Map maps = {};
    playlists.forEach((String key, Playlist value) => maps[key] = value.toDBMap());

    // create or overwrite file with current data
    playlistsFile.writeAsStringSync(JSON.encode(maps));
  }

  Playlist assignClientPlaylist(String clientID, String playlistName) {
    _clientPlaylists[clientID] = playlistName;

    // if the playlist exists, return it with its media List filled out
    if (playlists[playlistName] != null) {
      Playlist pl = playlists[playlistName];
      pl.media = pl.mediaNames.map((String name) => media[name]).toList(growable: false);
      return pl;
    }

    return null;
  }
}
