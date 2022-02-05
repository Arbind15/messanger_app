import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messanger_app/models/chat_users_models.dart';
import 'package:messanger_app/screens/chat_page.dart';
import 'package:messanger_app/widgets/conversation_list.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class JsonData {
  String user;

  JsonData(this.user);

  Map toJson() => {"username": user};
}

class AddNewChat extends StatefulWidget {
  const AddNewChat({Key? key, required this.navData}) : super(key: key);
  final NavData navData;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<AddNewChat> {
  String url = '/messaging/addhospital/';
  var chat_list = [];
  late final String user;

  void postData() async {
    final response = await http.get(Uri.parse(url));
    final recv_data = json.decode(response.body.toString());
    chat_list = new List.from(chat_list)..addAll(recv_data['Hospital']);
    setState(() {});
  }

  @override
  void initState() {
    user=widget.navData.user;
    url=widget.navData.baseUrl+url;
    print("Acchat");
    print(user);
    print(widget.navData.baseUrl);
    print(url);
    postData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.pink, //change your color here
        ),
        title: Text("Select Hospital",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink[50],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade200)),
              ),
            ),
            ListView.builder(
                itemCount: chat_list.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    name: chat_list[index],
                    messageText: 'Health Institution',
                    imageUrl: "https://randomuser.me/api/portraits/lego/3.jpg",
                    time: '',
                    isMessageRead: false,
                    user: user,
                    flag: 0,
                    baseUrl: widget.navData.baseUrl,
                    wsUrl: widget.navData.wsUrl,
                  );
                })
          ],
        ),
      ),
    );
  }
}
