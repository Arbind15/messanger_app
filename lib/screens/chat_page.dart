import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messanger_app/models/chat_users_models.dart';
import 'package:messanger_app/screens/chat_page.dart';
import 'package:messanger_app/widgets/conversation_list.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import 'add_new_chat.dart';

class NavData {
  final String user;
  final String hospital;
  final String baseUrl, wsUrl;
  final int flg;

  const NavData(this.user, this.hospital, this.flg, this.baseUrl, this.wsUrl);
}

class JsonData {
  String user;
  int flag;

  JsonData(this.user, this.flag);

  Map toJson() => {"username": user, "flag": flag};
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.nav_data}) : super(key: key);

  final NavData nav_data;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final String user = "cat";
  // final String hospital = "achham";
  // // 0 for user 1 for hospital
  // final int flag = 1;

  String user = "";
  String hospital = "";
  String baseURL = "";

  // 0 for user 1 for hospital
  int flag = 0;
  late final NavData nav_data;

  String url = '/messaging/chatlist/';

  var chat_list = [];

  void postData() async {
    final JsonData jsondata;

    if (flag == 0) {
      jsondata = JsonData(nav_data.user, flag);
    } else {
      jsondata = JsonData(nav_data.hospital, flag);
    }
    String jsonbody = jsonEncode(jsondata);
    final response = await http.post(Uri.parse(url), body: jsonbody);
    final recv_data = json.decode(response.body.toString());
    print(recv_data);
    chat_list = new List.from(chat_list)..addAll(recv_data['Users']);
    setState(() {});
    print(chat_list);
  }

  @override
  void initState() {
    user = widget.nav_data.user;
    hospital = widget.nav_data.hospital;
    // 0 for user 1 for hospital
    flag = widget.nav_data.flg;
    baseURL = widget.nav_data.baseUrl;
    url = baseURL + url;
    nav_data = NavData(user, hospital, flag, baseURL, widget.nav_data.wsUrl);
    print('homeC');
    print(nav_data.user);
    print(nav_data.hospital);
    postData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    (flag == 0)
                        ? Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.pink[50],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddNewChat(
                                    navData: NavData(
                                        widget.nav_data.user,
                                        widget.nav_data.hospital,
                                        widget.nav_data.flg,
                                        widget.nav_data.baseUrl,
                                        widget.nav_data.wsUrl),
                                  );
                                }));
                              },
                              child: Row(
                                children: const <Widget>[
                                  Icon(
                                    Icons.add,
                                    color: Colors.pink,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "Add New",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text('')
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ListView.builder(
                itemCount: chat_list.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    name: chat_list[index]['User'],
                    messageText: chat_list[index]['DateTime'],
                    imageUrl: (widget.nav_data.flg == 0)
                        ? "https://randomuser.me/api/portraits/lego/3.jpg"
                        : "https://randomuser.me/api/portraits/lego/5.jpg",
                    time: '',
                    isMessageRead: (index == 0 || index == 3) ? true : false,
                    user: (flag == 0) ? nav_data.user : nav_data.hospital,
                    flag: flag,
                    baseUrl: nav_data.baseUrl,
                    wsUrl: nav_data.wsUrl,
                  );
                })
          ],
        ),
      ),
    );
  }
}
