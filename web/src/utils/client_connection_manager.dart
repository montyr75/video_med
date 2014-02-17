library client_connection_manager;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/message.dart';
import 'package:VideoMed/playlist.dart';

class ClientConnectionManager extends Object with Observable {
  String _clientID;
  String _wsURL;
  WebSocket _webSocket;

  // event streams
  StreamController _onConnect = new StreamController.broadcast();
  StreamController _onDisconnect = new StreamController.broadcast();
  StreamController _onPlaylist = new StreamController.broadcast();

  @observable bool connecting = false;
  @observable bool connected = false;

  bool connectionPending = false;

  ClientConnectionManager();

  void connectToServer(clientID, serverIP, serverPort) {
    // reset status properties
    connecting = false;
    connected = false;
    connectionPending = false;

    _clientID = clientID;
    _wsURL = "ws://$serverIP:$serverPort/ws";

    print("ClientConnectionManager:: connecting $_clientID on $_wsURL");

    connecting = true;

    _webSocket = new WebSocket(_wsURL);

    _webSocket.onOpen.first.then((_) {
      print("ClientConnectionManager:: now connected on: ${_webSocket.url}");

      _webSocket.onMessage.listen((MessageEvent event) {
        _messageReceived(event.data);
      });

      _webSocket.onClose.first.then((_) {
        print("ClientConnectionManager:: disconnected on: ${_webSocket.url}");

        _disconnected();
      });

      // set status properties
      connecting = false;
      connected = true;
      connectionPending = false;

      // register client ID with server
      sendMessage(new Message(_clientID, Message.CLIENT_ID_REG, null));
    });

    _webSocket.onError.first.then((_) {
      _onConnect.addError(new StateError("Error connecting to server at ${_webSocket.url}"));
      _disconnected();
    });
  }

  void _messageReceived(String jsonStr) {
    Message message = new Message.fromMap(JSON.decode(jsonStr));

    print("ClientConnectionManager::_messageReceived():\n${message}");

    switch (message.type) {
      case Message.CLIENT_ID_REG_ACK: _onConnect.add(message.msg); break;
      case Message.CLIENT_ID_IN_USE: _onConnect.addError(new StateError("Client ID in use: ${message.msg}")); break;
      case Message.PLAYLIST: _onPlaylist.add(new Playlist.fromMessageMap(JSON.decode(message.msg))); break;
    }
  }

  void _disconnected() {
    // if this is already being handled, don't repeat the onDisconnect event
    if (connectionPending) {
      return;
    }

    connecting = false;
    connected = false;
    connectionPending = true;

    _onDisconnect.add(_clientID);
  }

  void sendMessage(Message msg) {
    _webSocket.sendString(JSON.encode(msg.toMap()));
  }

  void disconnect() {
    _webSocket.close();
  }

  String get clientID => _clientID;

  Stream<String> get onConnect => _onConnect.stream;
  Stream<String> get onDisconnect => _onDisconnect.stream;
  Stream<Playlist> get onPlaylist => _onPlaylist.stream;
}

