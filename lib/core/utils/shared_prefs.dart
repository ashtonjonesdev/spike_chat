import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_with_firebase/styles/constants.dart';

class SharedPrefs {

  static SharedPreferences _sharedPreferences;

  init() async {

    if(_sharedPreferences == null) {

      _sharedPreferences = await SharedPreferences.getInstance();

    }

  }

  bool get isValidated => _sharedPreferences.getBool(IS_VALIDATED_KEY) ?? false;

  set isValidated(bool validation) {

    _sharedPreferences.setBool(IS_VALIDATED_KEY, validation);

  }

  String get username => _sharedPreferences.getString(USERNAME_KEY) ?? null;

  set username(String username) {

    _sharedPreferences.setString(USERNAME_KEY, username);

  }



}

final sharedPrefs = SharedPrefs();