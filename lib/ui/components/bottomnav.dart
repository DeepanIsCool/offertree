import 'package:flutter/material.dart';
import 'package:offertree/ui/screens/chats/chats.dart';
import 'package:offertree/ui/screens/dashboard/home.dart';
import 'package:offertree/ui/screens/profile/profile.dart';
import 'package:offertree/ui/screens/ads/select_category.dart';
import 'package:offertree/ui/screens/ads/list_ads.dart';

Widget buildBottomNavigationBar(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
              'assets/svg/bottomnav/home_active.png',
              'Home',
              true,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard())
              )
          ),
          _buildNavItem(
              'assets/svg/bottomnav/chat_active.png',
              'Chat',
              false,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chats())
              )
          ),
          _buildAddButton(context),
          _buildNavItem(
              'assets/svg/bottomnav/myads_active.png',
              'Ads',
              false,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListAds())
              )
          ),
          _buildNavItem(
              'assets/svg/bottomnav/profile_active.png',
              'Profile',
              false,
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile())
              )
          ),
        ],
      ),
    ),
  );
}

Widget _buildNavItem(String imagePath, String label, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          height: 24,
          width: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.cyan[400] : Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}

Widget _buildAddButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SelectCategory())
      );
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.cyan[400],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    ),
  );
}