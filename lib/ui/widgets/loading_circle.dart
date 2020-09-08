import 'package:flutter/material.dart';
import 'package:stream_chat_with_firebase/styles/colors.dart';

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
          backgroundColor: kPrimaryColorLight,
        ),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}