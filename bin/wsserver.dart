library wsserver;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:route/server.dart' show Router;
import 'package:VideoMed/global.dart';
import 'package:VideoMed/message.dart';
import 'package:VideoMed/playlist.dart';

import 'model/model.dart';
import 'utils/server_connection_manager.dart';

Model model;
ServerConnectionManager scm = new ServerConnectionManager();

void main(List<String> arguments) {
  // set up argument parser (defaults in global.dart)
  ArgParser parser = new ArgParser()
    ..addOption('ip', defaultsTo: SERVER_IP)
    ..addOption('port', defaultsTo: SERVER_PORT.toString());

  // parse the command-line arguments
  ArgResults results = parser.parse(arguments);

  model = new Model();

  // start WebSocket server
  startServer(results['ip'], int.parse(results['port'], onError:(_) {
    print("Error: Invalid port");
    exit(1);
  }));
}

void startServer(String ip, int port) {
  // TODO: use InternetAddress class to obtain IP via DNS lookup

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
  // anything but a simple String needs to be JSON encoded and should have a toMessageMap() method
  if (msgContent is! String) {
    msgContent = JSON.encode(msgContent.toMessageMap());
  }

  // a sender ID of null indicates the message originates from the server
  ws.add(JSON.encode(new Message(null, msgType, msgContent).toMap()));
}

void registerClientID(String clientID, WebSocket ws) {
  print("Registering client: $clientID");

  // if the add fails, the ID is already in use
  if (!scm.add(clientID, ws)) {
    print("Client ID in use: $clientID");
    sendMessage(ws, Message.CLIENT_ID_IN_USE, clientID);
    ws.close();
    return;
  }

  sendMessage(ws, Message.CLIENT_ID_REG_ACK, clientID);

  if (clientID == ADMIN_ID) {
    sendMessage(scm[ADMIN_ID], Message.MODEL, JSON.encode(model.toAdminModelMap()));
  }
  else {
    // TODO: remove this debug code (admin will normally assign playlists to clients)
    sendClientPlaylist(clientID, model.assignClientPlaylist(clientID, "Sample Playlist"));
  }
}

void connectionClosed(WebSocket ws) {
  // if the ID is found in the client list, it will be unregistered and returned here
  String clientID = scm.remove(ws);

  print("WebSocket connection closed: $clientID");
}

void sendClientPlaylist(String clientID, Playlist pl) {
  // if the playlist is good, send it
  if (pl != null) {
    sendMessage(scm[clientID], Message.PLAYLIST, pl);
  }
}
