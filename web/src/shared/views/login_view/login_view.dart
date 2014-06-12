library login_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:videomed/global.dart';
import '../../../utils/client_connection_manager.dart';

@CustomTag('login-view')
class LoginView extends PolymerElement {

  static const CLASS_NAME = "LoginView";

  @published ClientConnectionManager ccm;
  @published bool admin = false;

  // UI properties
  @observable String clientID;    // for clients, ID persists into local storage automatically

  LoginView.created() : super.created();

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");

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
    print("$CLASS_NAME::registerClientID() -- $clientID");

    // connect and register client ID with server
    ccm.connectToServer(clientID, Uri.base.host, SERVER_PORT);    // this works as long as the server and client run from the same server machine
    //ccm.connectToServer(clientID, SERVER_IP, SERVER_PORT);      // use this way if the server IP differs from where the client runs
  }

  void _connected(String clientID) {
    print("$CLASS_NAME::connected() -- $clientID");
  }

  void _disconnected(String clientID) {
    print("$CLASS_NAME::disconnected() -- $clientID");

    // TODO: display status to user
  }

  void _connectionError(StateError error) {
    print("$CLASS_NAME::connectionError() -- ${error.message}");

    // TODO: display error to user
  }

  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }
}

