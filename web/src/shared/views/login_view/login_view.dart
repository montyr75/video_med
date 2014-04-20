library login_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:VideoMed/global.dart';
import '../../../utils/client_connection_manager.dart';

@CustomTag('login-view')
class LoginView extends PolymerElement {

  @published ClientConnectionManager ccm;
  @published bool admin = false;

  // UI properties
  @observable String clientID;    // for clients, ID persists into local storage automatically

  LoginView.created() : super.created();

  @override void enteredView() {
    super.enteredView();
    print("LoginView::enteredView()");

    // use standard admin ID from global.dart if the "client" is the admin
    if (admin) {
      clientID = ADMIN_ID;
    }
  }

  void ccmChanged(oldValue) {
    if (ccm == null) {
      return;
    }

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

    // the input is not present for admin login
    InputElement idInput = $['id-input'];
    if (idInput != null) {
      idInput.focus();
    }
  }

  void _registerClientID([String badClientID = null]) {
    print("LoginView::registerClientID() -- $clientID");

    // connect and register client ID with server
    ccm.connectToServer(clientID, SERVER_IP, SERVER_PORT);

    // TODO: if server and client host have the same IP, we can use this (we probably want this for production)
    //ccm.connectToServer(clientID, Uri.base.host, SERVER_PORT);
  }

  void _connected(String clientID) {
    print("LoginView::connected() -- $clientID");
  }

  void _disconnected(String clientID) {
    print("LoginView::disconnected() -- $clientID");

    // TODO: display status to user
  }

  void _connectionError(StateError error) {
    print("LoginView::connectionError() -- ${error.message}");

    // TODO: display error to user
  }

  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }
}

