import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        showBackButton: false,
        onBackPressed: () => Navigator.popUntil(context, (route) => false),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(
            onMessageSent: (message) =>
                print('Sending message: ${message.text}'),
          ),
        ],
      ),
    );
  }
}
