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
  FirebaseApp app =
      await Firebase.initializeApp().catchError((error) => print(error));

  runApp(ChangeNotifierProvider<AuthService>(
      child: MyApp(), create: (context) => AuthService()));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  Client _streamClient;
  Channel _streamChannel;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _userPhotoUrl;
  String _username;
  String _userTokenFromProvider;

  bool _isLoggedIn;

  @override
  void initState() {
    auth.FirebaseAuth.instance.authStateChanges().listen((auth.User user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          _isLoggedIn = false;
        });
      } else {
        print('User is signed in!');
        setState(() {
          _isLoggedIn = true;
        });
      }
    });
    // _initializeStreamClient();
    super.initState();
  }

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
        debugShowCheckedModeBanner: false,
        home: _isLoggedIn
            ? Home(firebaseUser: auth.FirebaseAuth.instance.currentUser)
            : Welcome()
        // FutureBuilder(
        //     future: Provider.of<AuthService>(context, listen: false).getAuthStateChanges().listen((event) { return event }),
        //     builder: (context, AsyncSnapshot<auth.User> snapshot) {
        //       if (snapshot.connectionState == ConnectionState.done) {
        //           _initializeUserData(username: snapshot.data.displayName ?? 'User',
        //               userPhotoUrl: snapshot.data.photoURL ?? 'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=1200&hei=1200',
        //               userTokenFromProvider: snapshot.data.getIdToken() ?? '-1');
        //           _initializeStreamClient();
        //
        //         if (snapshot.error != null) {
        //           print("error");
        //           return Text(snapshot.error.toString());
        //         }
        //         return snapshot.hasData
        //             ? Home(firebaseUser: snapshot.data, streamClient: widget._streamClient, streamChannel: widget._streamChannel,)
        //             : Welcome();
        //       } else {
        //         print('Loading...');
        //         return LoadingCircle();
        //       }
        //     }),
        );
  }

  //
  // void _initializeStreamClient() async {
  //
  //   print('Initializing Stream client...');
  //
  //   widget._streamClient = Client(
  //     'b67pax5b2wdq',
  //     logLevel: Level.INFO,
  //   );
  //
  //   await widget._streamClient.setUser(
  //     User(
  //       id: _username,
  //       extraData: {
  //         'image':
  //         _userPhotoUrl,
  //       },
  //     ),
  //     _userTokenFromProvider,
  //   );
  //
  //   widget._streamChannel = widget._streamClient.channel('messaging', id: 'spikeball',
  //     extraData: {
  //       'image':
  //       'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=1200&hei=1200',
  //     },);
  //
  //   // ignore: unawaited_futures
  //   widget._streamChannel.watch();
  //
  // }

  void _initializeUserData(
      {String userPhotoUrl,
      String username,
      Future<String> userTokenFromProvider}) async {
    _userPhotoUrl = userPhotoUrl;
    _username = username;
    _userTokenFromProvider = await userTokenFromProvider;
  }
}
