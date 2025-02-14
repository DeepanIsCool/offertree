import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:offertree/ui/components/bottomnav.dart';
import 'package:offertree/ui/screens/chats/chat_screens.dart';

class User {
  final String id;
  final String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username)';
  }
}


class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  _ChatsState createState() => _ChatsState();
}

class ChatItem {
  final String name;
  final String userId;
  bool isPinned;

  ChatItem({
    required this.name,
    required this.userId,
    this.isPinned = false,
  });
}

class _ChatsState extends State<Chats> {
  late List<ChatItem> _chats;
  late List<ChatItem> _originalChats;
  bool _isLoading = false;
  String? authToken;


  @override
  void initState() {
    super.initState();
    _chats = [];
    _originalChats = [];
    _fetchUsers();
  }


  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://offertree-backend.vercel.app/api/users'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}"); // Debugging response

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print("Parsed JSON Data: $jsonData");

        List<User> users = jsonData.map((data) => User.fromJson(data)).toList();
        print("Users List: $users");

        setState(() {
          _chats = users.map((user) => ChatItem(
            userId: user.id,
            name: user.username,
            isPinned: false,
          )).toList();
          _sortChats();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchUsers,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _chats.isEmpty
            ? const Center(
          child: Text(
            "No chats yet",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _chats.length,
          itemBuilder: (context, index) {
            final chat = _chats[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      name: chat.name,
                      userid: chat.userId,
                      avatar: '',
                    ),
                  ),
                );
              },
              onLongPress: () => _showOptionsBottomSheet(context, chat),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 24),
                  ),
                  title: Text(
                    chat.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: chat.isPinned
                      ? Row(
                    children: const [
                      Icon(Icons.push_pin_rounded,
                          size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        "Pinned",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, ChatItem chat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Iconsax.warning_2, color: Colors.orange),
                  title: const Text('Report User'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.trash, color: Colors.red),
                  title: const Text('Delete Chat'),
                  onTap: () {
                    setState(() {
                      _chats.remove(chat);
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.user, color: Colors.black),
                  title: const Text('Profile'),
                  onTap: () {

                  },
                ),
                ListTile(
                  leading: Icon(
                    chat.isPinned ? Icons.push_pin_rounded : Icons.push_pin_rounded,
                    color: const Color(0xFF000000),
                  ),
                  title: Text(chat.isPinned ? 'Unpin Chat' : 'Pin Chat'),
                  onTap: () {
                    setState(() {
                      chat.isPinned = !chat.isPinned;
                      _sortChats();
                    });
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sortChats() {
    _chats.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });
  }
}