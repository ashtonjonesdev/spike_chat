import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_with_firebase/ui/widgets/stream_chat_widgets.dart';

void main() async {
  final client = Client(
    'b67pax5b2wdq',
    logLevel: Level.INFO,
  );

  await client.setUser(
    User(
      id: 'old-grass-9',
      extraData: {
        'image':
            'https://getstream.io/random_png/?id=old-grass-9&amp;name=Old+grass',
      },
    ),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoib2xkLWdyYXNzLTkifQ.5oPKmqqz-GSqj_KzMLfXCY1YALdCTFecupzOVJUhxUw',
  );

  final channel = client.channel('messaging', id: 'godevs');

  // ignore: unawaited_futures
  channel.watch();

  runApp(MyApp(client, channel));

}

class MyApp extends StatelessWidget {
  final Client client;
  final Channel channel;


  MyApp(this.client, this.channel);

  // This needs to be called before any Firebase services can be used
  final Future<FirebaseApp> _initialization =
      Firebase.initializeApp().catchError((error) => print(error));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: ChannelPage(),
        ),
      ),
    );
  }
}
