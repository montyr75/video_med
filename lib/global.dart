library global;

import 'package:event_bus/event_bus.dart';

// constants
const String SERVER_IP = "192.168.1.6";   // not used if there is a valid SERVER_HOST name
const String SERVER_HOST = "Darkrealm";
const int SERVER_PORT = 9223;

// event bus
EventBus eventBus = new EventBus();

// events
final EventType<String> clientConnectedEvent = new EventType<String>();
final EventType<String> clientDisconnectedEvent = new EventType<String>();
final EventType<String> clientIDInUseEvent = new EventType<String>();