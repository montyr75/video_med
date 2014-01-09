library client_connection_manager;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:VideoMed/global.dart';
import 'package:VideoMed/message.dart';

class ClientConnectionManager {
  static const Duration RECONNECT_DELAY = const Duration(milliseconds: 500);

  String _clientID;
  String _wsURL = "ws://${Uri.base.host}:$PORT/ws";
  WebSocket _webSocket;
  
  ClientConnectionManager(this._clientID) {
    _connectToServer();
  }
  
  void _connectToServer() {
   _webSocket = new WebSocket(_wsURL);

    print("Client connecting on: $_wsURL");

    _webSocket.onOpen.first.then((_) {
      print("Client now connected on: ${_webSocket.url}");

      _webSocket.onMessage.listen((MessageEvent event) {
        _messageReceived(event.data);
      });

      _webSocket.onClose.first.then((_) {
        print("Client disconnected on: ${_webSocket.url}");
        
        _disconnected();

        // attempt to reconnect to the server
        //new Timer(RECONNECT_DELAY, _connectToServer);
      });
      
      sendMessage(CLIENT_ID_MSG, _clientID);
    });

    _webSocket.onError.first.then((_) {
      print("Client connection error on: ${_webSocket.url}");
    });
  }

  void _messageReceived(String jsonStr) {
    Message message = new Message.fromMap(JSON.decode(jsonStr));

    print("Client received message:\n${message}");
    
    switch (message.type) {
      case CLIENT_ID_ACK_MSG: eventBus.fire(clientConnectedEvent, message.msg); break;
    }
  }
  
  void _disconnected() {
    eventBus.fire(clientDisconnectedEvent, _clientID);
  }
  
  void sendMessage(String type, String msg) {
    _webSocket.sendString("{'$type': '$msg'}");
  }
  
  String get clientID => _clientID; 
}

