import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spike_chat/styles/theme.dart';
import 'package:spike_chat/ui/screens/entry_point.dart';
import 'package:spike_chat/ui/screens/home.dart';

import 'core/data/model/chat_model.dart';
import 'core/utils/shared_prefs.dart';

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




