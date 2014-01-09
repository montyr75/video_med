library main_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/global.dart';
import 'package:VideoMed/message.dart';
import '../../../utils/client_connection_manager.dart';
import 'package:event_bus/event_bus.dart';
import 'dart:async';

@CustomTag('main-view')
class MainView extends PolymerElement {
  
  ClientConnectionManager _ccm;
  StreamSubscription<String> _connectedEventSub;
  StreamSubscription<String> _disconnectedEventSub;

  MainView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");

    // listen for events
    _connectedEventSub = eventBus.on(clientConnectedEvent).listen(connected);
    _disconnectedEventSub = eventBus.on(clientDisconnectedEvent).listen(disconnected);
    
    // create connection manager
    _ccm = new ClientConnectionManager("client1");
  }
  
  void connected(String clientID) {
    print("MainView::connected() -- $clientID");
  }

  void disconnected(String clientID) {
    print("MainView::disconnected() -- $clientID");
  }

  void sendMessage(Event event, var detail, Element target) {
    
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

