library vmserver;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:route/server.dart' show Router;
import 'package:VideoMed/global.dart';
import 'package:VideoMed/message.dart';

import 'utils/client_manager.dart';

ClientManager clients = new ClientManager();

void main() {
  // look up the IP of the server host, then start the WebSocket server using it
  InternetAddress.lookup(SERVER_HOST, type: InternetAddressType.IP_V4)
    .then((List<InternetAddress> ipList) {
      startServer(ipList.first, SERVER_PORT);
    });
}

void startServer(InternetAddress ip, int port) {
  HttpServer.bind(ip, port).then((HttpServer server) {
    Router router = new Router(server);

    router.serve('/ws')
      .transform(new WebSocketTransformer())
      .listen(handleNewWebSocketConnection);

    print("VMServer is running on http://${server.address.address}:$port/");
  });
}

void handleNewWebSocketConnection(WebSocket ws) {
  print("New WebSocket connection");

  // listen for incoming messages
  ws.map((String string) => new Message.fromMap(JSON.decode(string))).listen((Message msg) {
      print("Server received message:\n${msg}");

      switch (msg.type) {
        case Message.CLIENT_ID_REG: registerClientID(msg.clientID, ws); break;
      }
  },
  onDone: () {
    connectionClosed(ws);
  });
}

void sendMessage(WebSocket ws, Message msg) {
  ws.add(JSON.encode(msg.toMap()));
}

void registerClientID(String clientID, WebSocket ws) {
  print("Registering client: $clientID");

  // if the add fails, the ID is already in use
  if (!clients.add(clientID, ws)) {
    print("Client ID in use: $clientID");
    sendMessage(ws, new Message(null, Message.CLIENT_ID_IN_USE, clientID));
    return;
  }

  sendMessage(ws, new Message(null, Message.CLIENT_ID_REG_ACK, clientID));
}

void connectionClosed(WebSocket ws) {
  // if the ID is found in the client list, it will be unregistered and returned here
  String clientID = clients.remove(ws);

  print("WebSocket connection closed: $clientID");
}