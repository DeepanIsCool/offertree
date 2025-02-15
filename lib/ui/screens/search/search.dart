import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/components/infinitecards.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchScreen> {
  List<Map<String, dynamic>> _allItems = []; // Initialize as empty
  List<Map<String, dynamic>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  String? _selectedLocation;
  double _minPrice = 0;
  double _maxPrice = 100;

  @override
  void initState() {
    super.initState();
    _fetchItems(); // Fetch items when the widget initializes
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch items from the API
  Future<void> _fetchItems() async {
    try {
      final response = await http
          .get(Uri.parse("https://offertree-backend.vercel.app/api/ads"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allItems = data
              .map<Map<String, dynamic>>(
                  (item) => Map<String, dynamic>.from(item))
              .toList();
          _filteredItems = List.from(_allItems); // Initialize filtered items
        });
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error fetching items: $e');
      // Handle error (e.g., show a snackbar or error message)
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesQuery =
            item['title'].toString().toLowerCase().contains(query) ||
                item['location'].toString().toLowerCase().contains(query);
        final matchesLocation =
            _selectedLocation == null || item['location'] == _selectedLocation;
        final matchesPrice =
            item['price'] >= _minPrice && item['price'] <= _maxPrice;

        return matchesQuery && matchesLocation && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(),
        title: Text(
          'Search Ads',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Iconsax.search_normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Filters
            Row(
              children: [
                // Location Dropdown (commented out for now)
                // Expanded(
                //   child: DropdownButton<String>(
                //     isExpanded: true,
                //     value: _selectedLocation,
                //     hint: const Text("Select Location"),
                //     items: _allItems
                //         .map((item) => item['location'].toString())
                //         .toSet()
                //         .map(
                //           (location) => DropdownMenuItem<String>(
                //         value: location,
                //         child: Text(location),
                //       ),
                //     )
                //         .toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         _selectedLocation = value;
                //         _applyFilters();
                //       });
                //     },
                //   ),
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      const Text('Price Range'),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          activeTrackColor: Color(0xFF576bd6),
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Color(0xFF576bd6),
                        ),
                        child: RangeSlider(
                          values: RangeValues(_minPrice, _maxPrice),
                          min: 0,
                          max: 2000,
                          divisions: 10,
                          labels: RangeLabels(
                            '\$${_minPrice.toInt()}',
                            '\$${_maxPrice.toInt()}',
                          ),
                          onChanged: (values) {
                            setState(() {
                              _minPrice = values.start;
                              _maxPrice = values.end;
                              _applyFilters();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // List of filtered items
            Expanded(
              child: _allItems.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading indicator
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return buildInfiniteCard(context, item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
