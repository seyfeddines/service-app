import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions_without_message.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getChatWithRealTimeChanges(String orderId);

  Future<List<MessageModel>> getChatWithOneTimeRead(String orderId);

  Future<void> addMessage(String orderId, MessageModel message);
}

class ChatFirestoreImpl extends ChatRemoteDataSource {
  @override
  Stream<List<MessageModel>> getChatWithRealTimeChanges(String orderId) async* {
    try {
      final chatStream = FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .orderBy('date', descending: true)
          .snapshots();

      await for (final chat in chatStream) {
        yield chat.docs
            .map((document) => MessageModel.fromFirestore(document))
            .toList();
      }
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getChatWithOneTimeRead(String orderId) async {
    try {
      final respons = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .orderBy('date', descending: true)
          .get();

      return respons.docs
          .map((document) => MessageModel.fromFirestore(document))
          .toList();
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> addMessage(String orderId, MessageModel message) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('chat')
          .add(message.toFirestore());
    } catch (error) {
      throw ServerException();
    }
  }
}
class FakeChatRemoteDataSource implements ChatRemoteDataSource {
  final List<MessageModel> _fakeMessages = [
    MessageModel(
      messageId: '1',
      message: 'Salam! 👋',
      messageType: 'text',
      date: DateTime.now().subtract(const Duration(minutes: 5)),
      senderId: 'user_1',
    ),
    MessageModel(
      messageId: '2',
      message: 'Labas 3lik?',
      messageType: 'text',
      date: DateTime.now().subtract(const Duration(minutes: 4)),
      senderId: 'service_giver_1',
    ),
    MessageModel(
      messageId: '3',
      message: 'https://picsum.photos/200/300',
      messageType: 'image',
      captionOfImage: 'Example image 📷',
      date: DateTime.now().subtract(const Duration(minutes: 3)),
      senderId: 'user_1',
    ),
  ];

  final _controller = StreamController<List<MessageModel>>.broadcast();

  FakeChatRemoteDataSource() {
    // Emit initial messages
    _controller.add(_fakeMessages);
  }

  @override
  Stream<List<MessageModel>> getChatWithRealTimeChanges(String orderId) {
    return _controller.stream;
  }

  @override
  Future<List<MessageModel>> getChatWithOneTimeRead(String orderId) async {
    return _fakeMessages;
  }

  @override
  Future<void> addMessage(String orderId, MessageModel message) async {
    final newMessage = message.copyWith(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
    );

    // أضف الرسالة الجديدة للقائمة
    final model = MessageModel.fromEntity(message);
    final entity = model.toEntity();

    // أرسل القائمة الجديدة للـ Stream
    _controller.add(List.from(_fakeMessages));
  }
}
