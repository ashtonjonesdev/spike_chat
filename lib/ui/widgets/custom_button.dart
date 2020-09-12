
import 'package:flutter/material.dart';
import 'package:spike_chat/styles/colors.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String buttonText;


  CustomButton({this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Material(
        color: kPrimaryColorLight,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 45,
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ),
    );
  }
}
