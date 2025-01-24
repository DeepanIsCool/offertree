import 'package:flutter/material.dart';
import 'package:offertree/ui/components/bottomnav.dart';
import 'package:offertree/ui/components/infinitecards.dart';

class ListAds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'All Ads',
            style: Theme.of(context).textTheme.titleMedium
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              buildInfiniteCard({
                'price': 29.99,
                'title': 'Sample Item',
                'location': 'New York',
              }),
              buildInfiniteCard({
                'price': 49.99,
                'title': 'Vintage Chair',
                'location': 'San Francisco',
              }),
              buildInfiniteCard({
                'price': 19.99,
                'title': 'Stylish Lamp',
                'location': 'Los Angeles',
              }),
              buildInfiniteCard({
                'price': 99.99,
                'title': 'Mountain Bike',
                'location': 'Denver',
              }),
              buildInfiniteCard({
                'price': 14.99,
                'title': 'Classic Books',
                'location': 'Boston',
              }),
              buildInfiniteCard({
                'price': 299.99,
                'title': 'Gaming Laptop',
                'location': 'Seattle',
              }),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
