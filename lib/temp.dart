import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';

class Data {
  final String id;
  final String name;

  Data({
    required this.name,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['emp_id'],
      id: json['firstname'],
    );
  }
}

Future<Data> fetchData() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Data.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController id = TextEditingController();
  var jsonResponse = [];
  //late Future<Data> futureData=fetchData();

  void GetReq() async {
    // var url =
    //     Uri.http('10.0.2.2:8000','');  //for emulator

    var url = Uri.http('192.168.1.4:8000',
        ''); //for phone, replace ip with ivp4 from ipconfig
    // and   python manage.py runserver 0.0.0.0:8000

    var response = await http.get(url);
    if (response.statusCode == 200) {
      //print(response.body.toString());
      jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);

      // var itemCount = jsonResponse['firstname'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      jsonResponse;
    });
  }

  void PostReq(List<String> arguments) async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
    // Uri.http('10.0.2.2:8000','',{'id':arguments[0],'name':arguments[1]});
    Uri.http('192.168.1.4:8000', '',
        {'id': arguments[0], 'name': arguments[1]});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(url);
    if (response.statusCode == 200) {
      //print(response.body.toString());
      jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);

      // var itemCount = jsonResponse['firstname'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      jsonResponse;
    });
  }

  void PostWithFile(List<String> arguments) async {
    var url =
    // Uri.http('10.0.2.2:8000','',{'id':arguments[0],'name':arguments[1]});
    Uri.http('192.168.1.71:8000', '', {
      'id': arguments[0],
      'name': arguments[1],
      'file': (await rootBundle.load('assets/xyz.jpg')).buffer.asUint8List().toString()
    });
    print(url.toString());
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(url);
    if (response.statusCode == 200) {
      //print(response.body.toString());
      jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);

      // var itemCount = jsonResponse['firstname'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      jsonResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your id',
                      ),
                      controller: id,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                      controller: name,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            print(name.text.toString());
                            print(id.text.toString());
                            PostReq([id.text.toString(), name.text.toString()]);
                            // PostWithFile([id.text.toString(), name.text.toString()]);
                            //GetReq();
                            //fetchData();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: jsonResponse.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {},
                      title: Text(jsonResponse[index]['firstname']),
                      subtitle: Text(jsonResponse[index]['emp_id']),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}





























import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messanger_app/models/chat_message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatData {
  String user, hospital, content;

  ChatData(this.user, this.hospital, this.content);

  Map toJson() => {"user": user, "hospital": hospital, "content": content};
}

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];

  final _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:8000/messages/chatupdatetmp/arbind/'),
  );

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      ChatData chat_data = ChatData("cat", "morang", _controller.text);
      String jsonData = jsonEncode(chat_data);
      _channel.sink.add(jsonData);
      messages.add(
          ChatMessage(messageContent: _controller.text, messageType: "sender"));
      _controller.text = '';
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _channel.stream.listen((recv_data) {
      final ch_data = json.decode(recv_data.toString());
      // print(ch_data);
      // {type: send_update, value: {Sender: cat, Content: ki, Date: 2022-02-02 17:45:24.505750, Seen_Status: False}}
      messages.add(ChatMessage(
          messageContent: ch_data['value']['Content'],
          messageType: "receiver"));
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
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/5.jpg"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Kriss Benwat",
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
          // StreamBuilder(
          //   stream: _channel.stream,
          //   builder: (context, snapshot) {
          //     // print(snapshot.hasData);
          //     if (snapshot.hasData) {
          //       // print(snapshot.data);
          //       print('recv');
          //       final ch_data = json.decode(snapshot.data.toString());
          //       // print(ch_data);
          //       // {type: send_update, value: {Sender: cat, Content: ki, Date: 2022-02-02 17:45:24.505750, Seen_Status: False}}
          //       messages.add(ChatMessage(
          //           messageContent: ch_data['value']['Content'],
          //           messageType: "receiver"));
          //     }
          //     print('builder');
          //     return Text("");
          //   },
          // ),
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
