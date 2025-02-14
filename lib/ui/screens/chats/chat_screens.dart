import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class ChatScreen extends StatefulWidget {
  final String name;
  final String avatar;
  final String userid;

  const ChatScreen(
      {Key? key,
        required this.name,
        required this.avatar,
        required this.userid})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  late int senderid;
  IO.Socket? socket;
  bool isConnecting = true;
  String? connectionError;

  Future<void> _initializeChat() async {
    try {
      await _fetchSenderId();
      if (senderid == null) {
        throw Exception('Failed to fetch sender ID');
      }

      _initializeSocket();
    } catch (e) {
      setState(() {
        connectionError = e.toString();
        isConnecting = false;
      });
      print('Initialization error: $e');
    }
  }

  Future<void> _fetchSenderId() async {
    try {
      final response = await http.get(
        Uri.parse('https://offertree-backend.vercel.app/api/profile'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          senderid = data['id'];
        });
        print('Sender ID: $senderid');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id', senderid!);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching sender ID: $e');
    }
  }

  void _initializeSocket() {
    // Initialize Socket.IO client
    socket = IO.io('https://offertree-backend.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Set up socket event handlers
    socket!.on('connect', (_) {
      print('Connected to socket server');
      setState(() {
        isConnecting = false;
        connectionError = null;
      });
    });

    socket!.on('connect_error', (data) {
      print('Failed to connect to server: $data');
      setState(() {
        connectionError = 'Connection failed: $data';
        isConnecting = false;
      });
    });

    socket!.on('disconnect', (_) {
      print('Disconnected from socket server');
      setState(() {
        isConnecting = true;
      });
    });

    socket!.on('message', (data) {
      print('Message received: $data');

      if (data is List) {
        // If multiple messages are received
        for (var message in data) {
          setState(() {
            messages.add({
              "text": message['text'],
              "type": message['msgByUserId'] == senderid ? "sent" : "received",
            });
          });
        }
      } else if (data is Map<String, dynamic>) {
        // If a single message is received
        setState(() {
          messages.add({
            "text": data['text'],
            "type": data['msgByUserId'] == senderid ? "sent" : "received",
          });
        });
      } else {
        print('Unexpected data format: $data');
      }
    });


    // Connect to the socket server
    socket!.connect();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty && socket != null) {
      final messageText = _messageController.text.trim();

      socket!.emit('new message', {
        'sender': senderid,
        'receiver': widget.userid,
        'text': messageText,
      });
      print('Message sent: $messageText');

      setState(() {
        messages.add({"text": messageText, "type": "sent"});
      });

      _messageController.clear();
    }
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isSent = message["type"] == "sent";
                return Align(
                  alignment:
                  isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSent ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(
                        color: isSent ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF576bd6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Iconsax.send_1, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

