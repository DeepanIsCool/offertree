import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/components/infinitecards.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchScreen> {
  final List<Map<String, dynamic>> _allItems = [
    {
      'price': 29.99,
      'title': 'Sample Item 1',
      'location': 'New York',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'price': 49.99,
      'title': 'Sample Item 2',
      'location': 'San Francisco',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'price': 19.99,
      'title': 'Sample Item 3',
      'location': 'Chicago',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'price': 39.99,
      'title': 'Sample Item 4',
      'location': 'Los Angeles',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'price': 59.99,
      'title': 'Sample Item 5',
      'location': 'Miami',
      'image': 'https://via.placeholder.com/150',
    },
  ];
  List<Map<String, dynamic>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  String? _selectedLocation;
  double _minPrice = 0;
  double _maxPrice = 100;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesQuery = item['title'].toString().toLowerCase().contains(query) ||
            item['location'].toString().toLowerCase().contains(query);
        final matchesLocation = _selectedLocation == null ||
            item['location'] == _selectedLocation;
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
                // Location Dropdown
                // Expanded(
                //   child:
                //   DropdownButton<String>(
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
                          max: 100,
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

            Expanded(
              child: ListView.builder(
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
