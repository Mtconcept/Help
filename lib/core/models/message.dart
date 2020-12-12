class Message {
  final String message;
  final String date;
  final String time;
  final bool isUser;
  final String taggedMessage;
  final String receiverId, senderId;
  Stream<bool> isRead;

  Message({
    this.message,
    this.date,
    this.time,
    this.isUser,
    this.taggedMessage,
    this.receiverId,
    this.senderId,
    this.isRead,
  });
}
