library main_view;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/global.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  static const Duration RECONNECT_DELAY = const Duration(milliseconds: 500);

  WebSocket _webSocket;

  MainView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");

    _connectToServer();
  }

  void _connectToServer() {
    String wsURL = "ws://${Uri.base.host}:$PORT/ws";

    _webSocket = new WebSocket(wsURL);

    print("Client connecting on: $wsURL");

    _webSocket.onOpen.first.then((_) {
      print("Client now connected on: ${_webSocket.url}");

      _webSocket.onMessage.listen((MessageEvent event) {
        _messageReceived(event.data);
      });

      _webSocket.onClose.first.then((_) {
        print("Client disconnected on: ${_webSocket.url}");

        // attempt to reconnect to the server
        //new Timer(RECONNECT_DELAY, _connectToServer);
      });
    });

    _webSocket.onError.first.then((_) {
      print("Client connection error on: ${_webSocket.url}");
    });
  }

  void _messageReceived(String msg) {
    Map msgMap = JSON.decode(msg);

    print("Client received message:\n${msgMap['msg']}");
  }

  void sendMessage(Event event, var detail, Element target) {
    _webSocket.sendString(JSON.encode({"msg": "Message from client."}));
  }

  // a sample event handler function
  void eventHandler(Event event, var detail, Element target) {
    print("MainView::eventHandler()");
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

