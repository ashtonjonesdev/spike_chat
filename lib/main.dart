import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_with_firebase/core/services/AuthService.dart';
import 'package:stream_chat_with_firebase/styles/theme.dart';
import 'package:stream_chat_with_firebase/ui/screens/about_developer.dart';
import 'package:stream_chat_with_firebase/ui/screens/home.dart';
import 'package:stream_chat_with_firebase/ui/screens/introduction.dart';
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

  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedIn = false;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'SpikeChat',
      theme: AppTheme.appThemeData,
        routes: {
          Home.routeName: (context) => Home(),
          SignIn.routeName: (context) => SignIn(),
          Register.routeName: (context) => Register(),
          AboutDeveloper.routeName: (context) => AboutDeveloper(),
          Introduction.routeName: (context) => Introduction(),
          'welcome': (context) => Welcome(),
        },
        debugShowCheckedModeBanner: false,
        home: _isLoggedIn
            ? Home(firebaseUser: auth.FirebaseAuth.instance.currentUser)
            : Welcome()
        );
  }
}
