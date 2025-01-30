import 'package:flutter/material.dart';
import 'package:offertree/ui/components/bottomnav.dart';
import 'package:offertree/ui/components/infinitecards.dart';

class ListAds extends StatefulWidget {
  @override
  _ListAdsState createState() => _ListAdsState();
}

class _ListAdsState extends State<ListAds> {
  String _selectedStatus = 'All';

  final List<Map<String, dynamic>> _ads = [
    {'price': 29.99, 'title': 'Sample Item', 'location': 'New York', 'status': 'Approved'},
    {'price': 49.99, 'title': 'Vintage Chair', 'location': 'San Francisco', 'status': 'Pending'},
    {'price': 19.99, 'title': 'Stylish Lamp', 'location': 'Los Angeles', 'status': 'Rejected'},
    {'price': 99.99, 'title': 'Mountain Bike', 'location': 'Denver', 'status': 'Approved'},
    {'price': 14.99, 'title': 'Classic Books', 'location': 'Boston', 'status': 'Pending'},
    {'price': 299.99, 'title': 'Gaming Laptop', 'location': 'Seattle', 'status': 'Rejected'},
  ];

  List<Map<String, dynamic>> get filteredAds {
    if (_selectedStatus == 'All') {
      return _ads;
    } else {
      return _ads.where((ad) => ad['status'] == _selectedStatus).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'All Ads',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filter bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Approved', 'Pending', 'Rejected']
                      .map((status) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: _selectedStatus == status,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected ? status : 'All';
                        });
                      },
                    ),
                  ))
                      .toList(),
                ),
              ),
              SizedBox(height: 16),
              // List of ads based on filter
              Expanded(
                child: ListView(
                  children: filteredAds
                      .map((ad) => buildInfiniteCard(context, ad))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
