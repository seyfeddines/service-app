import 'dart:io';

import '../../../../core/error/exceptions_without_message.dart';

abstract class ChatRemoteStorage {
  Future<String> upload(String orderId, String fileName, File file);
}

const folderName = 'chat';

/// Fake Storage implementation (بدون Firebase)
class FakeChatRemoteStorage implements ChatRemoteStorage {
  @override
  Future<String> upload(String orderId, String fileName, File file) async {
    try {
      // simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // بدل ما نرفع الملف، نرجع رابط وهمي
      return "https://fake-storage.com/$folderName/$orderId/$fileName";
    } catch (error) {
      throw ServerException();
    }
  }
}
