import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_with_firebase/core/services/AuthService.dart';
import 'package:stream_chat_with_firebase/ui/screens/home.dart';
import 'package:stream_chat_with_firebase/ui/screens/register.dart';
import 'package:stream_chat_with_firebase/ui/screens/sign_in.dart';
import 'package:stream_chat_with_firebase/ui/screens/welcome.dart';
import 'package:stream_chat_with_firebase/ui/widgets/loading_circle.dart';
import 'package:stream_chat_with_firebase/ui/widgets/stream_chat_widgets.dart';

void main() async {

  // This needs to be called before any Firebase services can be used
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();

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

  runApp(ChangeNotifierProvider(
      create: (context) => AuthService(), child: MyApp(client, channel)));
}

class MyApp extends StatelessWidget {
  final Client client;
  final Channel channel;

  MyApp(this.client, this.channel);



  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      routes: {
        Home.routeName: (context) => Home(),
        SignIn.routeName: (context) => SignIn(),
        Register.routeName: (context) => Register(),
        'welcome': (context) => Welcome(),
      },
      home: FutureBuilder(
          future: Provider.of<AuthService>(context, listen: false).getUser(),
          builder: (context, AsyncSnapshot<auth.User> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.error != null) {
                print("error");
                return Text(snapshot.error.toString());
              }
              return snapshot.hasData
                  ? Home(firebaseUser: snapshot.data)
                  : Welcome();
            } else {
              return LoadingCircle();
            }
          }),
    );
  }
}
