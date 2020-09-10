import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_with_firebase/core/services/AuthService.dart';
import 'package:stream_chat_with_firebase/ui/screens/about_developer.dart';
import 'package:stream_chat_with_firebase/ui/screens/introduction.dart';
import 'package:stream_chat_with_firebase/ui/screens/welcome.dart';
import 'package:stream_chat_with_firebase/ui/widgets/stream_chat_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  static final String routeName = 'home';

  final auth.User firebaseUser;

  Home({this.firebaseUser});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeyHome = GlobalKey<ScaffoldState>();

  String _userPhotoUrl;
  String _username;
  String _userTokenFromProvider;
  String _uID;

  Client _streamClient;
  Channel _streamChannel;

  @override
  // void initState() {
  //   _initializeUserData(
  //       username: widget.firebaseUser.displayName,
  //       userPhotoUrl: widget.firebaseUser.photoURL,
  //       userTokenFromProvider: widget.firebaseUser.getIdToken(),
  //       uID: widget.firebaseUser.uid);
  //   _initializeStreamClient();
  //   super.initState();
  // }

  // void _initializeStreamClient() async {
  //   print('Initializing Stream client...');

    // widget.streamClient = Client(
    //   'ck3vz6wvspd5',
    //   logLevel: Level.INFO,
    //   tokenProvider: (String username) {return getUserToken(_username);}
    // );

    // final streamClient = Client(
    //   '4874kgvau9jt',
    //   logLevel: Level.INFO,
    //   connectTimeout: Duration(milliseconds: 6000),
    //   receiveTimeout: Duration(milliseconds: 6000),
    // );
    //
    // String devToken = streamClient.devToken(_username);
    //
    // // await streamClient.setUser(
    // //   User(id: _username, extraData: {
    // //     'image': _userPhotoUrl,
    // //   }),
    // //   'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoibXV0ZS1maXJlZmx5LTIifQ.TtaZN6W0DNaFntjHJbGBhtGnIgTW6UNOAnejBJ-w8jQ',
    // // );
    //
    // await streamClient.setGuestUser(User(
    //   id: 'TJgrapes',
    //   extraData: {
    //     'image' : _userPhotoUrl
    //   }
    // ));

    // await widget.streamClient.setUserWithProvider(User(
    //   id: _username,
    //   extraData: {
    //     'image':
    //     _userPhotoUrl,
    //   }
    // ),);

  //   Channel channel = Channel(streamClient, 'messaging', 'spikeball_channel', {
  //     'image':
  //     'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=1200&hei=1200',
  //   },  );
  //
  //   streamClient.channel(channel.type, id: channel.id, extraData: channel.extraData);
  //
  //   _streamClient = streamClient;
  //
  //   _streamChannel = _streamChannel;
  //
  //   // streamChannel = streamClient.channel(
  //   //   'messaging',
  //   //   id: 'spikeball',
  //   //   extraData: {
  //   //     'image':
  //   //         'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=1200&hei=1200',
  //   //   },
  //   // );
  //
  //   // ignore: unawaited_futures
  //   // streamChannel.watch();
  // }
  //
  // Future<String> getUserToken(String string) {
  //   return widget.firebaseUser.getIdToken();
  // }
  //
  // void _initializeUserData(
  //     {String userPhotoUrl,
  //     String username,
  //     Future<String> userTokenFromProvider,
  //     String uID}) async {
  //   _userPhotoUrl = userPhotoUrl;
  //   _username = username;
  //   _userTokenFromProvider = await userTokenFromProvider;
  //   _uID = uID;
  // }

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
        Navigator.pushNamed(context, Introduction.routeName);
        break;
      case 'How I Built This':
        print('Tapped How I built this');
        // _openMediumArticle();
        break;
      case 'About Developer':
        print('Tapped About Developer');
        Navigator.pushNamed(context, AboutDeveloper.routeName);
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
              return {'Introduction', 'How I Built This', 'About Developer', 'Sign Out'}
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
      // body: StreamChatRoot(client: _streamClient, channel: _streamChannel),
      body: Center(
        child: Text(
          'HOME', style: Theme.of(context).textTheme.headline3,
        ),
      )
    );
  }
}
