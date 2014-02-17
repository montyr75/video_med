library server_connection_manager;

import 'dart:io';

class ServerConnectionManager {

  Map<String, WebSocket> _connections = {};

  ServerConnectionManager();

  bool add(String clientID, WebSocket ws) {
    // if client ID is in use, don't allow connection
    if (_connections.containsKey(clientID)) {
      return false;
    }

    _connections[clientID] = ws;

    return true;
  }

  String remove(WebSocket ws) {
    String clientID = _findClientID(ws);

    if (clientID != null) {
      _connections.remove(clientID);
    }

    return clientID;
  }

  String _findClientID(WebSocket ws) {
    // find a connected client's ID by WebSocket reference

    String clientID;

    _connections.forEach((String key, WebSocket value) {
      if (_connections[key] == ws) {
        clientID = key;
      }
    });

    return clientID;
  }

  WebSocket operator [](String clientID) => _connections[clientID];
}