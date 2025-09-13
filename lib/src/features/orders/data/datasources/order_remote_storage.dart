import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/error/exceptions_without_message.dart';

abstract class OrderRemoteStorage {
  Future<String> upload(String fileName, File file);
  Future<void> delete(String fileName);
}

const folderName = 'orders';

/// Fake implementation (للاستعمال في التطوير أو التست)
class FakeOrderRemoteStorage implements OrderRemoteStorage {
  final Map<String, String> _storage = {}; // نخزنو fake URLs هنا

  @override
  Future<String> upload(String fileName, File file) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // simulate delay
      final fakeUrl = 'https://fake-storage.com/$folderName/$fileName';
      _storage[fileName] = fakeUrl;
      return fakeUrl;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> delete(String fileName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200)); // simulate delay
      _storage.remove(fileName);
    } catch (error) {
      throw ServerException();
    }
  }
}

/// Firebase implementation (production)
class OrderFirebaseStorageImpl implements OrderRemoteStorage {
  @override
  Future<String> upload(String fileName, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('$folderName/$fileName');
      await ref.putFile(file);
      final downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> delete(String fileName) async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child('$folderName/$fileName')
          .delete();
    } catch (error) {
      throw ServerException();
    }
  }
}
