import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:offertree/ui/components/bottomnav.dart';


class Chats extends StatefulWidget {
  @override
  ChatsState createState() => ChatsState();
}

class ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Chats',
          style: Theme.of(context).textTheme.titleMedium,),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}