import 'package:flutter/material.dart';
import 'package:offertree/ui/screens/ads/private/ad_create.dart';
import 'package:offertree/ui/screens/chats/chats.dart';
import 'package:offertree/ui/screens/dashboard/home.dart';
import 'package:offertree/ui/screens/profile/profile.dart';
import 'package:offertree/ui/screens/ads/list_ads.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Dashboard(),
    Chats(),
    AddItemDetails(),
    ListAds(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            _buildNavItem(Iconsax.home, "Home", _currentIndex == 0,
                () => _onItemTapped(0)),
            _buildNavItem(Iconsax.message, "Chats", _currentIndex == 1,
                () => _onItemTapped(1)),
            _buildAddButton(),
            _buildNavItem(Iconsax.discount_circle, "Ads", _currentIndex == 3,
                () => _onItemTapped(3)),
            _buildNavItem(Iconsax.user, "Profile", _currentIndex == 4,
                () => _onItemTapped(4)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: Color(0xFF576bd6),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF576bd6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _onItemTapped(2),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF576bd6),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF576bd6).withOpacity(0.2),
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
}
