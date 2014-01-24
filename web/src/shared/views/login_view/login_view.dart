library login_view;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/global.dart';
import '../../../utils/client_connection_manager.dart';

@CustomTag('login-view')
class LoginView extends PolymerElement {

  @published ClientConnectionManager ccm;

  // UI properties
  @observable String clientID = "client1";    // TODO: don't initialize this here

  LoginView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("LoginView::enteredView()");

    // listen for events
    ccm.onConnect.listen(_connected, onError: _connectionError);
    ccm.onDisconnect.listen(_disconnected);
  }

  void connect(Event event, var detail, Element target) {
    if (ccm == null || !ccm.connected) {
      _registerClientID();
    }
    else {
      ccm.disconnect();
    }

    $['id-input'].focus();
  }

  void _registerClientID([String badClientID = null]) {
    print("ConnectionView::registerClientID() -- $clientID");

    // connect and register client ID with server
    ccm.connectToServer(clientID, SERVER_IP, SERVER_PORT);

    // if server and client host have the same IP, we can use this
    //ccm.connectToServer(clientID, Uri.base.host, SERVER_PORT);
  }

  void _connected(String clientID) {
    print("ConnectionView::connected() -- $clientID");
  }

  void _disconnected(String clientID) {
    print("ConnectionView::disconnected() -- $clientID");

    // TODO: display status to user
  }

  void _connectionError(StateError error) {
    print("ConnectionView::connectionError() -- ${error.message}");

    // TODO: display error to user
  }

  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }

  // this lets the global CSS bleed through into the Shadow DOM of this element
  bool get applyAuthorStyles => true;
}

