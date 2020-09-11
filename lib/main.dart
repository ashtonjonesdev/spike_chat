import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_with_firebase/core/data/model/chat_model.dart';
import 'package:stream_chat_with_firebase/core/utils/shared_prefs.dart';
import 'package:stream_chat_with_firebase/styles/theme.dart';
import 'package:stream_chat_with_firebase/ui/screens/entry_point.dart';
import 'package:stream_chat_with_firebase/ui/screens/home.dart';

void main() async {
  /// Initialize SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          },
          debugShowCheckedModeBanner: false,
          home: sharedPrefs.isValidated ? Home() : EntryPoint(),
        ));
  }
}




