import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_with_firebase/core/data/model/chat_model.dart';
import 'package:stream_chat_with_firebase/core/services/AuthService.dart';
import 'package:stream_chat_with_firebase/core/utils/shared_prefs.dart';
import 'package:stream_chat_with_firebase/styles/colors.dart';
import 'package:stream_chat_with_firebase/styles/theme.dart';
import 'package:stream_chat_with_firebase/ui/screens/about_developer.dart';
import 'package:stream_chat_with_firebase/ui/screens/home.dart';
import 'package:stream_chat_with_firebase/ui/screens/introduction.dart';
import 'package:stream_chat_with_firebase/ui/screens/register.dart';
import 'package:stream_chat_with_firebase/ui/screens/sign_in.dart';
import 'package:stream_chat_with_firebase/ui/screens/welcome.dart';
import 'package:stream_chat_with_firebase/ui/widgets/custom_button.dart';
import 'package:stream_chat_with_firebase/ui/widgets/custom_form.dart';
import 'package:stream_chat_with_firebase/ui/widgets/loading_circle.dart';
import 'package:stream_chat_with_firebase/ui/widgets/stream_chat_widgets.dart';

void main() async {
  /// Initialize SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  // FirebaseApp app =
  //     await Firebase.initializeApp().catchError((error) => print(error));

  runApp(MyAppStateless());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  final Client streamClient;
  final Channel streamChannel;

  MyApp(this.streamClient, this.streamChannel);

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

    return ChangeNotifierProvider<ChatModel>(
      create: (context) => ChatModel(),
      child: MaterialApp(
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
          home: Home(firebaseUser: auth.FirebaseAuth.instance.currentUser)),
    );
  }
}

class MyAppStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ChangeNotifierProvider<ChatModel>(
        create: (context) => ChatModel(),
        child: MaterialApp(
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
          home: sharedPrefs.isValidated ? MyHome() : EntryPoint(),
        ));
  }
}

class MyHome extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final chatModelProvider = Provider.of<ChatModel>(context);

    return sharedPrefs.username == null
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('SpikeChat',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: kAccentColor, fontSize: 24)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/app_icon.png',
                    width: 150,
                    height: 150,
                  ),
                  CustomForm(
                    textEditingController: _textEditingController,
                    formKey: _formKey,
                    hintText: 'Enter a username...',
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final userId = _textEditingController.value.text;
                        final client = chatModelProvider.streamClient;

                        sharedPrefs.username = userId;

                        await client.setUserWithProvider(User(
                            id: 'id_$userId',
                            extraData: {
                              'name': '$userId',
                              'image': 'https://picsum.photos/100/100'
                            }));

                        final channel = client
                            .channel('mobile', id: 'Spikeball', extraData: {
                          'image':
                              'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=400&hei=400&qlt=50'
                        });
                        channel.watch();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => StreamChat(
                                  streamChatThemeData: StreamChatThemeData
                                      .fromTheme(AppTheme.appThemeData.copyWith(
                                          textTheme:
                                              GoogleFonts.robotoTextTheme())),
                                  client: client,
                                  child: StreamChannel(
                                    channel: channel,
                                    child: ChannelPage(),
                                  ),
                                )));
                      }
                    },
                    buttonText: 'SUBMIT',
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('SpikeChat',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: kAccentColor, fontSize: 24)),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'images/app_icon.png',
                    width: 150,
                    height: 150,
                  ),
                  Material(
                    child: Text(
                      '${sharedPrefs.username}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 20),
                    ),
                  ),
                  CustomButton(
                    onPressed: () async {
                      final client = chatModelProvider.streamClient;

                      await client.setUserWithProvider(User(
                          id: 'id_${sharedPrefs.username}',
                          extraData: {
                            'name': '${sharedPrefs.username}',
                            'image': 'https://picsum.photos/100/100'
                          }));

                      final channel =
                          client.channel('mobile', id: 'Spikeball', extraData: {
                        'image':
                            'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=400&hei=400&qlt=50'
                      });
                      channel.watch();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => StreamChat(
                                streamChatThemeData:
                                    StreamChatThemeData.fromTheme(
                                        AppTheme.appThemeData.copyWith(
                                            textTheme:
                                                GoogleFonts.robotoTextTheme())),
                                client: client,
                                child: StreamChannel(
                                  channel: channel,
                                  child: ChannelPage(),
                                ),
                              )));
                    },
                    buttonText: 'CONTINUE',
                  )
                ],
              ),
            ),
          );
  }
}

class EntryPoint extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SpikeChat',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: kAccentColor)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'images/app_icon.png',
            width: 150,
            height: 150,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the passcode...',
              ),
              validator: (input) {
                if (input.isEmpty) {
                  return 'Enter some text';
                }
                if (input == 'spiketally') {
                  return null;
                }
                return 'You do not have access to this group';
              },
            ),
          ),
          CustomButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                sharedPrefs.isValidated = true;

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MyHome()));
              }
            },
            buttonText: 'VERIFY',
          )
        ],
      ),
    );
  }
}
