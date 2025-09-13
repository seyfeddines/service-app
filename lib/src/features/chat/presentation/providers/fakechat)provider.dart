import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FakeChatProvider with ChangeNotifier {
  static const _storageKey = 'fake_chat_messages';
  List<Map<String, dynamic>> _messages = [];

  FakeChatProvider() {
    _loadMessages();
  }

  List<Map<String, dynamic>> get messages => _messages;

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_messages.map((m) => _encodeMessage(m)).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_storageKey);
    if (encoded != null) {
      final List<dynamic> decoded = jsonDecode(encoded);
      _messages = decoded.map((m) => _decodeMessage(m)).toList().cast<Map<String, dynamic>>();
    } else {
      // Initial fake messages
      _messages = [
        {
          'text': 'Hello! This is a fake chat. 😊',
          'senderId': 'other',
          'date': DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
          'messageType': 'text',
        },
        {
          'text': 'You can type below and see your message appear instantly.',
          'senderId': 'other',
          'date': DateTime.now().subtract(const Duration(minutes: 1)).toIso8601String(),
          'messageType': 'text',
        },
      ];
      await _saveMessages();
    }
    notifyListeners();
  }

  Map<String, dynamic> _encodeMessage(Map<String, dynamic> msg) {
    final m = Map<String, dynamic>.from(msg);
    if (m['date'] is DateTime) {
      m['date'] = (m['date'] as DateTime).toIso8601String();
    }
    return m;
  }

  Map<String, dynamic> _decodeMessage(dynamic msg) {
    final m = Map<String, dynamic>.from(msg as Map);
    if (m['date'] is String) {
      m['date'] = DateTime.tryParse(m['date']) ?? DateTime.now();
    }
    return m;
  }

  Future<void> sendTextMessage(String text, String senderId) async {
    if (text.trim().isEmpty) return;
    _messages.insert(0, {
      'text': text,
      'senderId': senderId,
      'date': DateTime.now(),
      'messageType': 'text',
    });
    await _saveMessages();
    notifyListeners();
  }

  Future<void> sendImageMessage(String imagePath, String senderId, {String? caption}) async {
    _messages.insert(0, {
      'text': imagePath,
      'senderId': senderId,
      'date': DateTime.now(),
      'messageType': 'image',
      'captionOfImage': caption,
    });
    await _saveMessages();
    notifyListeners();
  }

  Future<void> sendAudioMessage(String audioPath, String senderId) async {
    _messages.insert(0, {
      'text': audioPath,
      'senderId': senderId,
      'date': DateTime.now(),
      'messageType': 'audio',
    });
    await _saveMessages();
    notifyListeners();
  }

  Future<void> sendLocationMessage(String location, String senderId, {String? geoCodingData}) async {
    _messages.insert(0, {
      'text': location,
      'senderId': senderId,
      'date': DateTime.now(),
      'messageType': 'location',
      'captionOfImage': geoCodingData,
    });
    await _saveMessages();
    notifyListeners();
  }

  Future<void> clearMessages() async {
    _messages.clear();
    await _saveMessages();
    notifyListeners();
  }
}