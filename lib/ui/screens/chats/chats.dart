import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/components/bottomnav.dart';

class User {
  final String id;
  final String username;

  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
    );
  }
}

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  _ChatsState createState() => _ChatsState();
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String lastSeen;
  final int unreadCount;
  final String avatar;
  final String userId;
  bool isPinned;

  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.lastSeen,
    required this.unreadCount,
    required this.avatar,
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
    _originalChats = [
      ChatItem(
        name: 'John Doe',
        lastMessage: 'Hey! How are you?',
        lastSeen: '10:30 AM',
        unreadCount: 2,
        avatar: 'assets/svg/Logo/splashlogo.png',
        userId: 'user1',
      ),
      ChatItem(
        name: 'Jane Smith',
        lastMessage: 'See you tomorrow!',
        lastSeen: 'Yesterday',
        unreadCount: 0,
        avatar: 'assets/svg/Logo/splashlogo.png',
        userId: 'user2',
      ),
      ChatItem(
        name: 'Alex Johnson',
        lastMessage: 'Let me know when you’re free.',
        lastSeen: 'Mon',
        unreadCount: 1,
        avatar: 'assets/svg/Logo/splashlogo.png',
        userId: 'user3',
        isPinned: true,
      ),
      ChatItem(
        name: 'Emma Wilson',
        lastMessage: 'Thanks for the update.',
        lastSeen: '8:45 AM',
        unreadCount: 0,
        avatar: 'assets/svg/Logo/splashlogo.png',
        userId: 'user4',
      ),
    ];
    _fetchUsers();
  }


  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      final fetchedUsers = [
        ChatItem(
          name: 'Michael Brown',
          lastMessage: 'Let’s catch up!',
          lastSeen: 'Yesterday',
          unreadCount: 0,
          avatar: 'assets/svg/Logo/splashlogo.png',
          userId: 'user5',
        ),
        ChatItem(
          name: 'Sophia Davis',
          lastMessage: 'Meeting at 5 PM.',
          lastSeen: 'Today',
          unreadCount: 3,
          avatar: 'assets/svg/Logo/splashlogo.png',
          userId: 'user6',
        ),
      ];

      setState(() {
        _chats = [..._originalChats, ...fetchedUsers];
        _sortChats();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Chats',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchUsers,
        child: _isLoading
            ? const Center()
            : _chats.isEmpty
            ? const Center(
          child: Text(
            "No chats",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.separated(
          itemCount: _chats.length,
          separatorBuilder: (context, index) => const SizedBox(height: 1),
          itemBuilder: (context, index) {
            final chat = _chats[index];
            return Container(
              color: const Color(0xFFF4F4F4),
              child: InkWell(
                onLongPress: () => _showOptionsBottomSheet(context, chat),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  leading: GestureDetector(
                    onTap: () {

                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: chat.avatar.isNotEmpty
                              ? Colors.transparent
                              : const Color(0xFFF4F4F4),
                          backgroundImage: chat.avatar.isNotEmpty
                              ? AssetImage(chat.avatar)
                              : null,
                          radius: 25,
                          child: chat.avatar.isEmpty
                              ? Icon(Icons.person,
                              color: Colors.grey[400])
                              : null,
                        ),
                        if (chat.unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: -5.5,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${chat.unreadCount}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        chat.lastSeen,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: TextStyle(color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.isPinned)
                        const Icon(Icons.push_pin_rounded,
                            size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
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