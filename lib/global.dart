library global;

import 'package:event_bus/event_bus.dart';

// constants
const int PORT = 9223;

// message types
const CLIENT_ID_MSG = "client id";                    // message identifies client to server
const CLIENT_ID_ACK_MSG = "client id acknowledge";    // server acknowledges client ID registration

// event bus
EventBus eventBus = new EventBus();

// events
final EventType<String> clientConnectedEvent = new EventType<String>();
final EventType<String> clientDisconnectedEvent = new EventType<String>();