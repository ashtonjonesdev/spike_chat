import 'package:flutter/material.dart';
import 'package:spike_chat/core/utils/shared_prefs.dart';
import 'package:spike_chat/styles/colors.dart';
import 'package:spike_chat/ui/widgets/custom_button.dart';

import 'home.dart';

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
              obscureText: true,
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
                    .push(MaterialPageRoute(builder: (_) => Home()));
              }
            },
            buttonText: 'VERIFY',
          )
        ],
      ),
    );
  }
}