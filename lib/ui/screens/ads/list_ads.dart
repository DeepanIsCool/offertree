import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offertree/ui/components/bottomnav.dart';
import 'package:offertree/ui/components/infinitecards.dart';

class ListAds extends StatefulWidget {
  @override
  _ListAdsState createState() => _ListAdsState();
}

class _ListAdsState extends State<ListAds> {
  String _selectedStatus = 'All';
  late Future<List<Map<String, dynamic>>> _futureAds;

  @override
  void initState() {
    super.initState();
    _futureAds = fetchAds();
  }

  Future<List<Map<String, dynamic>>> fetchAds() async {
    final response = await http
        .get(Uri.parse("https://offertree-backend.vercel.app/api/ads"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Ensure each item is a map
      return data
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    } else {
      throw Exception('Failed to load ads');
    }
  }

  List<Map<String, dynamic>> filterAds(List<Map<String, dynamic>> ads) {
    if (_selectedStatus == 'All') {
      return ads;
    } else {
      return ads.where((ad) => ad['status'] == _selectedStatus).toList();
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
                  children: ['All', 'New', 'Pending', 'Rejected']
                      .map((status) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _futureAds,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error.toString()}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No ads found.'));
                    }
                    final filteredAds = filterAds(snapshot.data!);
                    return ListView(
                      children: filteredAds
                          .map((ad) => buildInfiniteCard(context, ad))
                          .toList(),
                    );
                  },
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
