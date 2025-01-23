import 'package:flutter/material.dart';
import 'package:offertree/ui/components/bottomnav.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _nickname = 'Demo User';
  String _username = 'username123';

  Widget _buildListTile(String title, {
    bool showModify = false,
    bool showArrow = true,
    VoidCallback? onTap,
    Icon? leadingIcon
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: leadingIcon,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: showModify
            ? const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: Color(0xFF000000),
            ),
          ],
        )
            : showArrow
            ? const Icon(
          Icons.chevron_right,
          color: Color(0xFF000000),
        )
            : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        leading: BackButton(),
        title: Text('My Profile',
          style: Theme.of(context).textTheme.titleMedium,),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header
                Row(
                  children: [
                    // Profile Picture
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                          image: AssetImage('assets/svg/Logo/splashlogo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nickname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _username.length > 14
                              ? _username.substring(0, 14)
                              : _username,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 32),

                _buildListTile(
                  'My Ads',
                  showModify: true,
                ),
                _buildListTile(
                  'Subscription',
                  showModify: true,
                ),
                const SizedBox(height: 32),

                _buildListTile(
                  'Favourties',
                ),
                _buildListTile(
                  'Terms & Conditions',
                ),
                _buildListTile(
                  'Privacy Policy',
                ),
                _buildListTile(
                  'Delete Account',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }
}