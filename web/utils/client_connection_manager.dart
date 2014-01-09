library client_connection_manager;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/global.dart';
import 'package:VideoMed/message.dart';

class ClientConnectionManager extends Object with Observable {
  String _clientID;
//  String _wsURL = "ws://${Uri.base.host}:$PORT/ws";   // this one will work in production
  String _wsURL = "ws://${SERVER_IP}:$SERVER_PORT/ws";
  WebSocket _webSocket;

  @observable bool connecting = false;
  @observable bool connected = false;

  bool connectionPending = false;

  ClientConnectionManager(this._clientID) {
    _connectToServer();
  }

  void _connectToServer() {
    print("ClientConnectionManager:: connecting on: $_wsURL");
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

      connecting = false;
      connected = true;
      connectionPending = false;

      // register client ID with server
      sendMessage(new Message(_clientID, Message.CLIENT_ID_REG, null));
    });

    _webSocket.onError.first.then((_) {
      print("ClientConnectionManager:: connection error on: ${_webSocket.url}");

      _disconnected();
    });
  }

  void _messageReceived(String jsonStr) {
    Message message = new Message.fromMap(JSON.decode(jsonStr));

    print("ClientConnectionManager::_messageReceived():\n${message}");

    switch (message.type) {
      case Message.CLIENT_ID_REG_ACK: eventBus.fire(clientConnectedEvent, message.msg); break;
      case Message.CLIENT_ID_IN_USE: eventBus.fire(clientIDInUseEvent, message.msg); break;
    }
  }

  void _disconnected() {
    // if this is already being handled, don't repeat the connection retry
    if (connectionPending) {
      return;
    }

    connecting = false;
    connected = false;
    connectionPending = true;

    eventBus.fire(clientDisconnectedEvent, _clientID);
  }

  void sendMessage(Message msg) {
    _webSocket.sendString(JSON.encode(msg.toMap()));
  }

  void disconnect() {
    _webSocket.close();
  }

  String get clientID => _clientID;
}

