library message;

class Message {
  // message types
  static const String CLIENT_ID_REG = "client ID registration";   // identifies client to server (msg: none)
  static const String CLIENT_ID_REG_ACK = "client id reg ack";    // server acknowledges client ID registration (msg: clientID)
  static const String CLIENT_ID_IN_USE = "client id in use";      // server rejects ID registration because it's in use (msg: rejected clientID)

  String clientID;    // null indicates server
  String type;
  String msg;

  Message(this.clientID, this.type, this.msg);

  Message.fromMap(Map<String, String> map) : this(map['clientID'], map['type'], map['msg']);

  Map<String, String> toMap() {
    return {
      'clientID': clientID,
      'type': type,
      'msg': msg
    };
  }

  @override String toString() {
    return "From: $clientID -- Type: $type -- Message: $msg";
  }
}