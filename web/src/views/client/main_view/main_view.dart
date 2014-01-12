library main_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:event_bus/event_bus.dart';
import 'package:VideoMed/global.dart';
import '../../../utils/client_connection_manager.dart';

@CustomTag('main-view')
class MainView extends PolymerElement {

  @observable ClientConnectionManager ccm;

  StreamSubscription<String> _connectedEventSub;
  StreamSubscription<String> _disconnectedEventSub;
  StreamSubscription<String> _clientIDInUseEventSub;

  // UI properties
  @observable String clientID = "client1";    // TODO: don't initialize this here

  MainView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("MainView::enteredView()");

    // listen for events
    _connectedEventSub = eventBus.on(clientConnectedEvent).listen(_connected);
    _disconnectedEventSub = eventBus.on(clientDisconnectedEvent).listen(_disconnected);
    _clientIDInUseEventSub = eventBus.on(clientIDInUseEvent).listen(_registerClientID);
  }

  void connect(Event event, var detail, Element target) {
    _registerClientID();
  }

  void disconnect(Event event, var detail, Element target) {
    ccm.disconnect();
  }

  void _registerClientID([String badClientID = null]) {
    print("MainView::registerClientID() -- $clientID");

    // if badClientID is filled, we tried to register an ID already in use
    if (badClientID != null) {
      print("MainView::registerClientID() -- Client ID in use");
      // TODO: prompt user for new client ID
      return;
    }

    // create connection manager and register client ID with server
    ccm = new ClientConnectionManager(clientID);
  }

  void _connected(String clientID) {
    print("MainView::connected() -- $clientID");
  }

  void _disconnected(String clientID) {
    print("MainView::disconnected() -- $clientID");
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

