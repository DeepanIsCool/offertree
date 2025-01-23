import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  @override
  ChatsState createState() => ChatsState();
}

class ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Chat Screen'),
      ),
    );
  }
}