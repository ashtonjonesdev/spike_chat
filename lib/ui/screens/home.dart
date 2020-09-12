import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spike_chat/core/data/model/chat_model.dart';
import 'package:spike_chat/core/utils/shared_prefs.dart';
import 'package:spike_chat/styles/colors.dart';
import 'package:spike_chat/styles/theme.dart';
import 'package:spike_chat/ui/widgets/custom_button.dart';
import 'package:spike_chat/ui/widgets/custom_form.dart';
import 'package:spike_chat/ui/widgets/stream_chat_widgets.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Home extends StatelessWidget {
  static final String routeName = 'home';

  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final chatModelProvider = Provider.of<ChatModel>(context);

    return sharedPrefs.username == null
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('SpikeChat',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: kAccentColor, fontSize: 24)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/app_icon.png',
                    width: 150,
                    height: 150,
                  ),
                  CustomForm(
                    textEditingController: _textEditingController,
                    formKey: _formKey,
                    hintText: 'Enter a username...',
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final userId = _textEditingController.value.text;
                        final client = chatModelProvider.streamClient;

                        sharedPrefs.username = userId;

                        await client.setUserWithProvider(User(
                            id: 'id_$userId',
                            extraData: {
                              'name': '$userId',
                              'image': 'https://picsum.photos/100/100'
                            }));

                        final channel = client
                            .channel('mobile', id: 'Spikeball', extraData: {
                          'image':
                              'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=400&hei=400&qlt=50'
                        });
                        channel.watch();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => StreamChat(
                                  streamChatThemeData: StreamChatThemeData
                                      .fromTheme(AppTheme.appThemeData.copyWith(
                                          textTheme:
                                              GoogleFonts.robotoTextTheme())),
                                  client: client,
                                  child: StreamChannel(
                                    channel: channel,
                                    child: ChannelPage(),
                                  ),
                                )));
                      }
                    },
                    buttonText: 'SUBMIT',
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('SpikeChat',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: kAccentColor, fontSize: 24)),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'images/app_icon.png',
                    width: 150,
                    height: 150,
                  ),
                  Material(
                    child: Text(
                      '${sharedPrefs.username}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 20),
                    ),
                  ),
                  CustomButton(
                    onPressed: () async {
                      print('Clicked continue!');

                      final client = chatModelProvider.streamClient;

                      await client.setUserWithProvider(User(
                          id: 'id_${sharedPrefs.username}',
                          extraData: {
                            'name': '${sharedPrefs.username}',
                            'image': 'https://picsum.photos/100/100'
                          }));

                      final channel =
                          client.channel('mobile', id: 'Spikeball', extraData: {
                        'image':
                            'https://scheels.scene7.com/is/image/Scheels/85375900555?wid=400&hei=400&qlt=50'
                      });
                      channel.watch();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => StreamChat(
                                client: client,
                                child: StreamChannel(
                                  channel: channel,
                                  child: ChannelPage(),
                                ),
                              )));
                    },
                    buttonText: 'CONTINUE',
                  )
                ],
              ),
            ),
          );
  }
}
