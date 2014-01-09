library message;

class Message {
  String type;
  String msg;
  
  Message(this.type, this.msg);
  
  Message.fromMap(Map<String, String> map) : this(map['type'], map['msg']);
  
  Map<String, String> toMap() {
    return {
      'type': type,
      'msg': msg
    };
  }
  
  @override String toString() {
    return "Message Type: $type -- Message: $msg";
  }
}