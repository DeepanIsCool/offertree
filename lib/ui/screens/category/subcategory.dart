import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offertree/ui/screens/ads/list_ads.dart';

class Subcategory extends StatefulWidget {
  final int categoryId;
  final String? name;

  const Subcategory({Key? key, required this.categoryId, required this.name})
      : super(key: key);

  @override
  _SubcategoryState createState() => _SubcategoryState();
}

class _SubcategoryState extends State<Subcategory> {
  late Future<List<ApplianceItem>> _futureAppliances;

  @override
  void initState() {
    super.initState();
    _futureAppliances = fetchSubcategories();
  }

  Future<List<ApplianceItem>> fetchSubcategories() async {
    final response = await http
        .get(Uri.parse('https://offertree-backend.vercel.app/api/subcategory'));

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      // Filter items by matching the passed categoryId with each item's id
      List<ApplianceItem> items = jsonList
          .where((item) => item['categoryId'] == widget.categoryId)
          .map<ApplianceItem>((item) {
        return ApplianceItem(
          // You can customize the icon based on the API response if necessary.
          icon: Icon(Icons.cloud),
          title: item['name'] ?? 'Select Subcategory',
        );
      }).toList();

      return items;
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          widget.name ?? 'Unknown',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ApplianceItem>>(
        future: _futureAppliances,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final appliances = snapshot.data ?? [];
          if (appliances.isEmpty) {
            return Center(child: Text('No categories found'));
          }
          return ListView.separated(
            itemCount: appliances.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.transparent,
              thickness: 0.2,
            ),
            itemBuilder: (context, index) {
              return ListTile(
                minVerticalPadding: 8,
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    'assets/house.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                title: Text(
                  appliances[index].title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                onTap: () {
                  //All Ads Page
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ApplianceItem {
  final Icon icon;
  final String title;

  ApplianceItem({
    required this.icon,
    required this.title,
  });
}
