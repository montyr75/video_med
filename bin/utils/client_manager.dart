library client_manager;

import 'dart:io';

class ClientManager {
  Map<String, WebSocket> _clients = {};   // map of currently connected clients

  bool add(String clientID, WebSocket ws) {
    if (_clients.containsKey(clientID)) {
      return false;
    }

    _clients[clientID] = ws;

    return true;
  }

  String remove(WebSocket ws) {
    String clientID = _findClientID(ws);

    if (clientID != null) {
      _clients.remove(clientID);
    }

    return clientID;
  }

  String _findClientID(WebSocket ws) {
    String clientID;

    _clients.forEach((String key, WebSocket value) {
      if (value == ws) {
        clientID = key;
      }
    });

    return clientID;
  }

  WebSocket operator [](String clientID) => _clients[clientID];
}