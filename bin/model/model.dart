library server_model;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:VideoMed/media.dart';
import 'package:VideoMed/playlist.dart';

class Model {

  static Model model;
  
  List<Media> _media;
  List<Playlist> _playlists;
  Map<String, ClientProfile> _clientProfiles;
  Map<String, ClientProfile> _connectedClients;

  factory Model() {
    print("Model()");

    // allow only one instance
    if (model == null) {
      model = new Model._internal();
    }

    return model;
  }

  Model._internal() {
    List<Future> futures = [];

    // load all data
//    dataSources.forEach((dataSource) {
//      futures.add(HttpRequest.getString(dataSource['path']));
//    });

//    Future.wait(futures).then((List values) {
//      print(JSON.decode(values[0]));
//    });
  }
  
  ClientProfile clientConnected(String clientID, WebSocket ws) {
    if (_connectedClients.containsKey(clientID)) {
      return null;
    }

    // if the client's profile exists, use it -- otherwise, make a new profile
    _connectedClients[clientID] = _clientProfiles.containsKey(clientID) ? _clientProfiles[clientID] : new ClientProfile(ws);

    return _connectedClients[clientID];
  }

  String clientDisconnected(WebSocket ws) {
    String clientID = _findClientID(ws);

    if (clientID != null) {
      _connectedClients.remove(clientID);
    }

    return clientID;
  }

  String _findClientID(WebSocket ws) {
    // find a connected client's ID by WebSocket reference
    
    String clientID;

    _connectedClients.forEach((String key, ClientProfile value) {
      if (value.ws != null && value.ws == ws) {
        clientID = key;
      }
    });

    return clientID;
  }

  ClientProfile operator [](String clientID) => _connectedClients[clientID];
}

class ClientProfile {
  String currentPlaylistName;
  WebSocket ws;             // reference to current socket connection
  
  ClientProfile([this.ws, this.currentPlaylistName]);
  
  ClientProfile.fromMap(Map map, [this.ws]) {
    if (map["currentPlaylist"] != null) {
      currentPlaylistName = map["currentPlaylistName"];
    }
  }
  
  Map toMap() {
    return {
      "currentPlaylistName": currentPlaylistName
    };
  }
}