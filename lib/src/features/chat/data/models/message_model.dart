import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required String messageId,
    required String message,
    required String messageType,
    String? captionOfImage,
    required DateTime date,
    required String senderId,
  }) : super(
    messageId: messageId,
    message: message,
    messageType: messageType,
    captionOfImage: captionOfImage,
    date: date,
    senderId: senderId,
  );

  /// From Firestore
  factory MessageModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    return MessageModel(
      messageId: document.id,
      message: document.data()['message'],
      messageType: document.data()['message_type'],
      captionOfImage: document.data()['caption_of_image'],
      date: (document.data()['date'] as Timestamp).toDate(),
      senderId: document.data()['sender_id'],
    );
  }

  /// To Firestore
  Map<String, dynamic> toFirestore() => {
    'message': message,
    'message_type': messageType,
    'caption_of_image': captionOfImage,
    'date': date,
    'sender_id': senderId,
  };

  /// From Entity
  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      messageId: entity.messageId,
      message: entity.message,
      messageType: entity.messageType,
      captionOfImage: entity.captionOfImage,
      date: entity.date,
      senderId: entity.senderId,
    );
  }

  /// To Entity
  Message toEntity() => Message(
    messageId: messageId,
    message: message,
    messageType: messageType,
    captionOfImage: captionOfImage,
    date: date,
    senderId: senderId,
  );
}
