class CommunicationLog {
  final String msgId;
  final String senderId;
  final String? receiverId;
  final String payload;
  final int hopCount;
  final int timestamp;
  final bool isDelivered;

  CommunicationLog({
    required this.msgId,
    required this.senderId,
    this.receiverId,
    required this.payload,
    this.hopCount = 0,
    required this.timestamp,
    this.isDelivered = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'msg_id': msgId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'payload': payload,
      'hop_count': hopCount,
      'timestamp': timestamp,
      'is_delivered': isDelivered ? 1 : 0,
    };
  }

  factory CommunicationLog.fromMap(Map<String, dynamic> map) {
    return CommunicationLog(
      msgId: map['msg_id'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      payload: map['payload'],
      hopCount: map['hop_count'],
      timestamp: map['timestamp'],
      isDelivered: map['is_delivered'] == 1,
    );
  }
}
