import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spike_chat/styles/constants.dart';
import 'package:start_jwt/json_web_signature.dart';
import 'package:start_jwt/json_web_token.dart';
import 'package:stream_chat/stream_chat.dart';


class ChatModel extends ChangeNotifier {
  Client _streamClient;


  ChatModel() {
    _streamClient = Client(STREAM_API_KEY,
        logLevel: Level.SEVERE, tokenProvider: tokenProvider);
  }

  Client get streamClient => _streamClient;

  /// Use the start_jwt package to create a json web token, by sending the STREAM_API_SECRET and generating a token using that secret, and specify a user id field
  Future<String> tokenProvider(String id) async {
    final JsonWebTokenCodec jwt = JsonWebTokenCodec(secret: STREAM_API_SECRET);

    final payload = {
      'user_id': id,
    };
    return jwt.encode(payload);
  }

}
