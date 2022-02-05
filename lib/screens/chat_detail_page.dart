import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:messanger_app/models/chat_message_model.dart';
import 'package:messanger_app/screens/chat_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';

class JsonData {
  String user, hospital;
  int flag;

  JsonData(this.user, this.hospital, this.flag);

  Map toJson() => {"username": user, "hospital": hospital, "flag": flag};
}

class ChatData {
  String user, hospital, content, sender;

  ChatData(this.user, this.hospital, this.content, this.sender);

  Map toJson() => {
        "user": user,
        "hospital": hospital,
        "content": content,
        "sender": sender
      };
}

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key, required this.nav_data}) : super(key: key);
  final NavData nav_data;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  var messages = [];
  late final String user;
  late final String hospital;
  late final int flag;
  final _controller = TextEditingController();
  String postUrl = '/messaging/chatdetails/';
  String baseUrl = '';

  // final ipv4 =  Ipify.ipv4();
  // print(ipv4); // 98.207.254.136

  static late String wsUrl = 'ws://:8000/messages/chatupdatetmp/arbind/';

  // String wsUrl='/messages/chatupdatetmp/arbind/';
  // var _channel;

  var Scontroller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  final _channel = WebSocketChannel.connect(
      // 'ws://10.0.2.2:8000/messages/chatupdatetmp/arbind/'  for emulator
      //   'ws://127.0.0.1:8000/messages/chatupdatetmp/arbind/' for local host
      //   Uri.parse('ws://192.168.43.173:8000/messages/chatupdatetmp/arbind/'), for mobile
      // Uri.parse(wsUrl), 192.168.1.66
      Uri.parse('ws://192.168.43.173:8000/messages/chatupdatetmp/arbind/'));
      // Uri.parse('ws://192.168.1.66:8000/messages/chatupdatetmp/arbind/'));

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      ChatData chat_data = ChatData(
          user, hospital, _controller.text, (flag == 0) ? user : hospital);
      String jsonData = jsonEncode(chat_data);
      _channel.sink.add(jsonData);
      messages.add(
          ChatMessage(messageContent: _controller.text, messageType: "sender"));
      _controller.text = '';
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Scontroller.animateTo(Scontroller.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.ease);
    });
    setState(() {});
  }

  void postData() async {
    messages = [];
    JsonData jsondata = JsonData(user, hospital, flag);
    String jsonbody = jsonEncode(jsondata);
    final response = await http.post(Uri.parse(postUrl), body: jsonbody);
    var recv_data = json.decode(response.body.toString());
    print(recv_data);
    recv_data = recv_data['payload']['chatList'];
    for (int i = 0; i < recv_data!.length; i++) {
      messages.add(ChatMessage(
          messageContent: recv_data[i]['Content'],
          messageType: (flag == 0)
              ? (recv_data[i]['Sender'] == user)
                  ? "sender"
                  : "receiver"
              : (recv_data[i]['Sender'] == hospital)
                  ? "sender"
                  : "receiver"));
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Scontroller.animateTo(Scontroller.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.ease);
    });
    setState(() {});
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user = widget.nav_data.user;
    hospital = widget.nav_data.hospital;
    flag = widget.nav_data.flg;
    baseUrl = widget.nav_data.baseUrl;
    postUrl = baseUrl + postUrl;
    // wsUrl=widget.nav_data.wsUrl+wsUrl;
    print('Cdetal');
    print(user);
    print(hospital);

    postData();

    print(wsUrl);

    // final _channel = WebSocketChannel.connect(
    //   // 'ws://10.0.2.2:8000/messages/chatupdatetmp/arbind/'
    //   Uri.parse(wsUrl),
    // );

    _channel.stream.listen((recv_data) {
      final ch_data = json.decode(recv_data.toString());
      // print(ch_data);
      // {type: send_update, value: {Sender: cat, Content: ki, Date: 2022-02-02 17:45:24.505750, Seen_Status: False}}
      messages.add(ChatMessage(
          messageContent: ch_data['value']['Content'],
          messageType: "receiver"));

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Scontroller.animateTo(Scontroller.position.maxScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.ease);
      });

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage((widget.nav_data.flg == 0)
                      ? "https://randomuser.me/api/portraits/lego/3.jpg"
                      : "https://randomuser.me/api/portraits/lego/5.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (flag == 0)
                          ? Text(
                              hospital,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          : const Text(
                              "User",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          const SizedBox(height: 24),
          SingleChildScrollView(
            controller: Scontroller,
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 65),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 3, bottom: 3),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      // width: 200,
                      constraints: BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType == "receiver"
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
