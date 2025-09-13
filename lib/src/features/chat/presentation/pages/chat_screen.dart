import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../../account/presentation/providers/account.dart';
import '../providers/fakechat)provider.dart';
import '../providers/recording_provider.dart';
import '../providers/text_field_filled_color.dart';
import '../widgets/appBar_builder.dart';
import '../widgets/message_sender/audio_sender/record_and_play_voice.dart';

import '../widgets/chat_body/message_bubble.dart';
import '../../domain/entities/message.dart';
import '../widgets/message_sender/message_sender_fake.dart';


class ChatScreen extends StatelessWidget {
  static const routName = '/chat-screen';

  const ChatScreen({
    required this.orderId,
    required this.otherPersonName,
    required this.otherPersonImage,
    required this.otherPersonPhoneNumber,
    required this.readOnly,
    Key? key,
  }) : super(key: key);

  final String orderId;
  final String otherPersonName;
  final String otherPersonImage;
  final String otherPersonPhoneNumber;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecordingProvider()),
        ChangeNotifierProvider(create: (context) => FakeChatProvider()),
      ],
      builder: (ctx, child) {
        return Scaffold(
          appBar: appBarBuilder(
            ctx,
            otherPersonName,
            otherPersonImage,
            otherPersonPhoneNumber,
            readOnly,
          ),
          body: Column(
            children: [
              Expanded(
                child: readOnly
                    ? const _ReadOnlyContainer('This Chat is read only')
                    : Stack(
                  children: [
                    FakeChatBody(
                      orderId,
                      otherPersonImage,
                      otherPersonName,
                    ),
                    const PositionedDirectional(
                      bottom: -50,
                      end: 5,
                      child: LockRecordingContainer(),
                    ),
                  ],
                ),
              ),
              readOnly
                  ? const _ReadOnlyContainer('This Chat is read only')
                  : Consumer2<RecordingProvider, FakeChatProvider>(
                      builder: (ctx, recordingProvider, fakeChatProvider, child) {
                        return Stack(
                          children: [
                            MessageSenderFake(orderId: orderId, fakeChatProvider: fakeChatProvider),
                            if (recordingProvider.recordingFromBottomSheet)
                              RecordingBottomSheet(orderId),
                          ],
                        );
                      },
                    ),


// MessageSenderFake widget for fake chat UI only
            ],
          ),
        );
      },
    );
  }
}

class FakeChatBody extends StatelessWidget {
  const FakeChatBody(
      this.orderId,
      this.otherPersonImage,
      this.otherPersonName, {
        Key? key,
      }) : super(key: key);

  final String orderId;
  final String otherPersonImage;
  final String otherPersonName;

  @override
  Widget build(BuildContext context) {
    return Consumer<FakeChatProvider>(
      builder: (context, chatProvider, child) {
        final messages = chatProvider.messages;
        final currentUser = Provider.of<Account>(context, listen: false);

        if (messages.isEmpty) {
          return const Center(
            child: Text('There are no messages!'),
          );
        }

        // Convert map messages to Message entities for compatibility with MessageBubble
        final fakeMessages = messages.asMap().entries.map((entry) {
          final index = entry.key;
          final messageData = entry.value; // This is a Map<String, dynamic>
          DateTime date;
          if (messageData['date'] is DateTime) {
            date = messageData['date'] as DateTime;
          } else if (messageData['date'] is String) {
            date = DateTime.tryParse(messageData['date']) ?? DateTime.now();
          } else {
            date = DateTime.now();
          }
          return Message(
            messageId: 'fake_$index',
            message: messageData['text'] as String,
            date: date,
            senderId: messageData['senderId'] as String,
            messageType: messageData['messageType'] as String,
            captionOfImage: messageData['captionOfImage'] as String?,
          );
        }).toList();

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemCount: fakeMessages.length,
          itemBuilder: (ctx, index) => MessageBubble(
            fakeMessages[index].message,
            fakeMessages[index].date,
            currentUser.image,
            otherPersonImage,
            otherPersonName,
            fakeMessages[index].messageType,
            fakeMessages[index].captionOfImage,
            currentUser.idIsMe(fakeMessages[index].senderId),
          ),
        );
      },
    );
  }
}

// Existing RecordingBottomSheet and LockRecordingContainer remain unchanged
class RecordingBottomSheet extends StatelessWidget {
  const RecordingBottomSheet(this.orderId, {super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      color: getTextFieldFilledColor(context),
      child: RecordAndPlayVoice(orderId),
    );
  }
}

class LockRecordingContainer extends StatelessWidget {
  const LockRecordingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingProvider>(
      builder: (ctx, provider, child) {
        return AnimatedContainer(
          duration: Durations.short1,
          decoration: BoxDecoration(
            color: getTextFieldFilledColor(ctx),
            borderRadius: BorderRadius.circular(50),
          ),
          height: provider.recordingFromTextField ? 170 : 0,
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.lock, color: Colors.grey.shade700),
              const SizedBox(height: 20),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ).animate(
                  onPlay: (controller) {
                    controller.loop(reverse: true);
                  },
                ).moveY(end: 5, duration: 400.ms),
              ),
            ],
          ),
        ).animate(
          onPlay: (controller) {
            controller.loop(reverse: true);
          },
        ).scaleY(
          end: 1.05,
          duration: 1.seconds,
          curve: Curves.fastOutSlowIn,
        );
      },
    );
  }
}

class _ReadOnlyContainer extends StatelessWidget {
  const _ReadOnlyContainer(
      this.title, {
        Key? key,
      }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade300,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}