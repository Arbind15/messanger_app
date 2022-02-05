import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:messanger_app/screens/chat_page.dart';

// http://10.0.2.2:8000/  for emulator baseurl

class ModeSelector extends StatefulWidget {
  const ModeSelector({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ModeSelector> {
// Initial Selected Value

  TextEditingController Usercontroller = TextEditingController();
  TextEditingController Hoscontroller = TextEditingController();
  TextEditingController Modecontroller = TextEditingController();
  TextEditingController Linkcontroller = TextEditingController();
  TextEditingController WScontroller = TextEditingController();

// List of items in our dropdown menu
  List users = [];
  List hospitals = [];
  final String url = 'http://10.0.2.2:8000/messaging/getmodelist/';

  void postData() async {
    final response = await http.post(Uri.parse(url), body: '');
    final recvData = json.decode(response.body.toString());
    users = new List.from(users)..addAll(recvData['payload']['users']);
    hospitals = List.from(hospitals)..addAll(recvData['payload']['hospitals']);
  }

  @override
  void initState() {
    // postData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: Usercontroller,
              decoration: InputDecoration(
                  hintText: "Username",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
            ),
            TextField(
              controller: Hoscontroller,
              decoration: InputDecoration(
                  hintText: "Hospital",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
            ),
            TextField(
              controller: Modecontroller,
              decoration: InputDecoration(
                  hintText: "Mode",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
            ),
            TextField(
              controller: Linkcontroller,
              decoration: InputDecoration(
                  hintText: "Base Url",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
            ),
            // TextField(
            //   controller: WScontroller,
            //   decoration: InputDecoration(
            //       hintText: "Web socket URL",
            //       hintStyle: TextStyle(
            //           fontWeight: FontWeight.w300, color: Colors.black)),
            // ),
            SizedBox(
              height: 50,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatPage(
                      nav_data: NavData(
                          Usercontroller.text.toString(),
                          Hoscontroller.text.toString(),
                          int.parse(Modecontroller.text),
                          Linkcontroller.text+(':8000').toString(),
                          WScontroller.text.toString()),
                    );
                  }));
                  setState(() {});
                },
                child: Text("Procceed")),
          ],
        ),
      ),
    );
  }
}
