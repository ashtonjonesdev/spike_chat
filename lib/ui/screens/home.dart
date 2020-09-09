import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_with_firebase/core/services/AuthService.dart';
import 'package:stream_chat_with_firebase/ui/screens/welcome.dart';
import 'package:stream_chat_with_firebase/ui/widgets/stream_chat_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  static final String routeName = 'home';

  final auth.User firebaseUser;

  Client _streamClient;
  Channel _streamChannel;

  Home({this.firebaseUser});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeyHome = GlobalKey<ScaffoldState>();

  String _userPhotoUrl;
  String _username;
  String _userTokenFromProvider;

  @override
  void initState() {
    _initializeUserData(username: widget.firebaseUser.displayName, userPhotoUrl: widget.firebaseUser.photoURL, userTokenFromProvider: widget.firebaseUser.getIdToken());
    _initializeStreamClient();
    super.initState();
  }

  void _initializeStreamClient() async {

    print('Initializing Stream client...');

    widget._streamClient = Client(
      '76e98frdxw7f',
      logLevel: Level.INFO,
    );

    await widget._streamClient.setUser(
      User(
        id: 'super-band-9',
        extraData: {
          'image':
          _userPhotoUrl,
        },
      ),
      '3734c5bfpwjrd5n2fzywgqtufd3xr96zdvn2qqef696qe9q63wfeac9eazdc7e44',
    );

    widget._streamChannel = widget._streamClient.channel('messaging', id: 'spikeball',
      extraData: {
        'image':
        'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=1200&hei=1200',
      },);

    // ignore: unawaited_futures
    widget._streamChannel.watch();

  }

  void _initializeUserData({String userPhotoUrl, String username, Future<String> userTokenFromProvider}) async {
    _userPhotoUrl = userPhotoUrl;
    _username = username;
    _userTokenFromProvider = await userTokenFromProvider;
  }

  void _signOut() async {
    await Provider.of<AuthService>(context, listen: false).signout();
    if (await Provider.of<AuthService>(context, listen: false).getUser() ==
        null) {
      print('Successfully signed out user');
    } else {
      print('Failed to sign out user!');
    }
  }

  void _handleMenuItemClick(String value) {
    switch (value) {
      case 'Introduction':
        print('Tapped Introduction');
        Navigator.pushNamed(context, 'welcome');
        break;
      case 'How I built this':
        print('Tapped Tips');
        // _openMediumArticle();
        break;
      case 'About Developer':
        print('Tapped About Developer');
        // Navigator.pushNamed(context, AboutDeveloper.routeName);
        break;
      case 'Sign Out':
        print('Tapped Sign Out');
        _signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Welcome()),
            (Route<dynamic> route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return StreamChatRoot(client: widget.streamClient, channel: widget.streamChannel);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuItemClick,
            itemBuilder: (BuildContext context) {
              return {'Introduction', 'Tips', 'About Developer', 'Sign Out'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: StreamChatRoot(client: widget._streamClient, channel: widget._streamChannel),
    );
  }
}
