import 'package:flutter/material.dart';

Widget buildBottomNavigationBar() {
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
          _buildNavItem('assets/svg/bottomnav/home_active.png', 'Home', true),
          _buildNavItem('assets/svg/bottomnav/chat_active.png', 'Chat', false),
          _buildAddButton(),
          _buildNavItem('assets/svg/bottomnav/myads_active.png', 'Ads', false),
          _buildNavItem('assets/svg/bottomnav/profile_active.png', 'Profile', false),
        ],
      ),
    ),
  );
}

Widget _buildNavItem(String imagePath, String label, bool isSelected) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        imagePath,
        height: 24, // Adjust size as needed
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
  );
}
Widget _buildAddButton() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.cyan[400],
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.cyan.withOpacity(0.2),
          spreadRadius: 4,
          blurRadius: 6,
          offset: Offset(0, 4), // Shadow position
        ),
      ],
    ),
    child: const Icon(
      Icons.add,
      color: Colors.white,
      size: 30,
    ),
  );
}

