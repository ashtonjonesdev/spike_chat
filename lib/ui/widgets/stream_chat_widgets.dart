import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_with_firebase/core/data/model/chat_model.dart';
import 'package:stream_chat_with_firebase/styles/colors.dart';

class StreamChatRoot extends StatelessWidget {
  final Client client;
  final Channel channel;



  StreamChatRoot({this.client, this.channel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: ChannelPage(),
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(showBackButton: false,
        onBackPressed: () => Navigator.popUntil(context, (route) => false),),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(
            onMessageSent: (message) => print('Sending message: ${message.text}'),
          ),
        ],
      ),
    );
  }
}

class ChannelView extends StatelessWidget {

  Stream<List<Channel>> getChannels(StreamChatState state)  {

    final filter = {
      "type": "mobile",
    };

    final sort = [
      SortOption(
        "last_message_at",
        direction: SortOption.DESC
      ),
    ];

    return state.client.queryChannels(
      filter: filter,
      sort: sort
    );

  }

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final streamClient = streamChat.client;
    final chatModelProvider = Provider.of<ChatModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Channel List', style: Theme
            .of(context)
            .textTheme
            .bodyText2,),
        centerTitle: true,
        backgroundColor: kPrimaryColorLight,
        leading: Hero(
          tag: 'logo',
          child: Container(
            padding: EdgeInsets.all(8),
            child: Image.asset('images/app_icon.png'),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: getChannels(streamChat),
            builder: (_, AsyncSnapshot<List<Channel>> snapshot) {
              if(!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.data.length == 0) {
                return Container();
              }
              return ListView(
                scrollDirection: Axis.vertical,
                // children: [createListOfChannels(snapshot.data, context)],
              );
            },
          ),

        ],
      ),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelsBloc(
        child: ChannelListView(
          filter: {
            'members': {
              '\$in': [StreamChat.of(context).user.id],
            }
          },
          sort: [SortOption('last_message_at')],
          pagination: PaginationParams(
            limit: 20,
          ),
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }
}


