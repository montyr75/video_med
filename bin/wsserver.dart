library wsserver;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:route/server.dart' show Router;
import 'package:VideoMed/global.dart';
import 'package:VideoMed/message.dart';
import 'package:VideoMed/playlist.dart';

import 'utils/client_manager.dart';

ClientManager clients = new ClientManager();

void main(List<String> arguments) {
  // set up argument parser (defaults in global.dart)
  ArgParser parser = new ArgParser()
    ..addOption('ip', defaultsTo: SERVER_IP)
    ..addOption('port', defaultsTo: SERVER_PORT.toString());

  // parse the command-line arguments
  ArgResults results = parser.parse(arguments);

  // start WebSocket server
  startServer(results['ip'], int.parse(results['port'], onError:(_) {
    print("Error: Invalid port");
    exit(1);
  }));
}

void startServer(String ip, int port) {
  HttpServer.bind(ip, port).then((HttpServer server) {
    Router router = new Router(server);

    router.serve('/ws')
      .transform(new WebSocketTransformer())
      .listen(handleNewWebSocketConnection);

    print("Server is running on http://${server.address.address}:$port/");
  });
}

void handleNewWebSocketConnection(WebSocket ws) {
  print("New WebSocket connection");

  // listen for incoming messages on this socket
  ws.map((String string) => new Message.fromMap(JSON.decode(string))).listen((Message msg) {
      print("Server received message:\n${msg}");

      switch (msg.type) {
        case Message.CLIENT_ID_REG: registerClientID(msg.senderID, ws); break;
      }
  },
  onDone: () {
    connectionClosed(ws);
  });
}

void sendMessage(WebSocket ws, String msgType, msgContent) {
  // anything but a simple String needs to be JSON encoded
  if (msgContent is! String) {
    msgContent = JSON.encode(msgContent.toMap());
  }

  // a clientID of null indicates the message originates from the server
  ws.add(JSON.encode(new Message(null, msgType, msgContent).toMap()));
}

void registerClientID(String clientID, WebSocket ws) {
  print("Registering client: $clientID");

  // if the add fails, the ID is already in use
  if (!clients.add(clientID, ws)) {
    print("Client ID in use: $clientID");
    sendMessage(ws, Message.CLIENT_ID_IN_USE, clientID);
    return;
  }

  sendMessage(ws, Message.CLIENT_ID_REG_ACK, clientID);

  // TODO: Here, we look up the clientID in the persisted client data, and if there is a
  // playlist assigned, we send it
  sendCurrentPlaylist(clientID);
}

void connectionClosed(WebSocket ws) {
  // if the ID is found in the client list, it will be unregistered and returned here
  String clientID = clients.remove(ws);

  print("WebSocket connection closed: $clientID");
}

void sendCurrentPlaylist(String clientID) {
  Playlist pl = new Playlist.fromMap({
    "id": "000",
    "title": "Sample Playlist",
    "description": "A sample playlist.",
    "media": [
      {
        "id": "001",
        "category": "Sample Category",
        "type": "video",
        "title": "Small",
        "description": "A small sample video.",
        "filename": "small.webm",
        "runtime": "00:05",
        "version": "1.0",
        "language": "en-US"
      },
      {
        "id": "002",
        "category": "Sample Category",
        "type": "video",
        "title": "Bunny",
        "description": "A larger sample video.",
        "filename": "bunny.webm",
        "runtime": "00:32",
        "version": "1.0",
        "language": "en-US"
      }
    ]
  });

  sendMessage(clients[clientID], Message.PLAYLIST, pl);
}