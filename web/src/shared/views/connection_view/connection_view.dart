library connection_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:event_bus/event_bus.dart';
import 'package:VideoMed/global.dart';
import '../../../utils/client_connection_manager.dart';

@CustomTag('connection-view')
class ConnectionView extends PolymerElement {

  @observable ClientConnectionManager ccm;

  StreamSubscription<String> _connectedEventSub;
  StreamSubscription<String> _disconnectedEventSub;
  StreamSubscription<String> _clientIDInUseEventSub;

  // UI properties
  @observable String clientID = "client1";    // TODO: don't initialize this here

  ConnectionView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("ConnectionView::enteredView()");

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
    print("ConnectionView::registerClientID() -- $clientID");

    // if badClientID is filled, we tried to register an ID already in use
    if (badClientID != null) {
      print("ConnectionView::registerClientID() -- Client ID in use");
      // TODO: prompt user for new client ID
      return;
    }

    // create connection manager and register client ID with server
    ccm = new ClientConnectionManager(clientID);
  }

  void _connected(String clientID) {
    print("ConnectionView::connected() -- $clientID");
  }

  void _disconnected(String clientID) {
    print("ConnectionView::disconnected() -- $clientID");
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

