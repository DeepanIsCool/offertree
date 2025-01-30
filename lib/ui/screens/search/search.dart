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
      'image': 'assets/svg/Logo/splashlogo.png'
    },
    {
      'price': 49.99,
      'title': 'Sample Item 2',
      'location': 'San Francisco',
      'image': 'assets/svg/Logo/splashlogo.png'
    },
    {
      'price': 19.99,
      'title': 'Sample Item 3',
      'location': 'Chicago',
      'image': 'assets/svg/Logo/splashlogo.png'
    },
    {
      'price': 39.99,
      'title': 'Sample Item 4',
      'location': 'Los Angeles',
      'image': 'assets/svg/Logo/splashlogo.png'
    },
    {
      'price': 59.99,
      'title': 'Sample Item 5',
      'location': 'Miami',
      'image': 'assets/svg/Logo/splashlogo.png'
    },
  ];
  List<Map<String, dynamic>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems
          .where((item) =>
      item['title'].toString().toLowerCase().contains(query) ||
          item['location'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.white,
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
