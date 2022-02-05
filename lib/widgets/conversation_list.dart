import 'package:flutter/material.dart';
import 'package:messanger_app/screens/chat_detail_page.dart';
import 'package:messanger_app/screens/chat_page.dart';

class ConversationList extends StatefulWidget {
  String name;

  // user: (flag==0)?nav_data.user:nav_data.hospital,
  String user;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  int flag;
  String baseUrl, wsUrl;

  ConversationList(
      {required this.name,
      required this.user,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.baseUrl,
      required this.wsUrl,
      required this.flag});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return (widget.flag == 0)
              ? ChatDetailPage(
                  nav_data: NavData(
                      widget.user, widget.name, widget.flag, widget.baseUrl,widget.wsUrl))
              : ChatDetailPage(
                  nav_data: NavData(
                      widget.name, widget.user, widget.flag, widget.baseUrl,widget.wsUrl));
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (widget.flag == 0) ? widget.name : "User",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
