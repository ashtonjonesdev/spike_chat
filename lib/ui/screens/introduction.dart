import 'package:flutter/material.dart';

class Introduction extends StatelessWidget {

  static final String routeName = 'introduction';


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('SpikeChat is a messaging app I built using Stream, Flutter and Firebase to create a group chat app for me and my friends to plan times to play Spikeball', style: Theme.of(context).textTheme.bodyText2,),
    );
  }
}
