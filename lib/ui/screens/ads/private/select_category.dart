import 'package:flutter/material.dart';
import 'package:offertree/ui/screens/ads/private/select_sub_category.dart';

class SelectCategory extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"name": "Home appliances", "icon": ""},
    {"name": "Furniture, ", "icon": ""},
    {"name": "Clothing & Accessories", "icon": ""},
    {"name": "Pets", "icon": ""},
    {"name": "Cars & Vehicles", "icon": ""},
    {"name": "Electronics", "icon": ""},
    {"name": "Cameras & Imaging", "icon": ""},
    {"name": "Jewelry & Watches", "icon": ""},
    {"name": "Mobile Phones & Tablets", "icon": ""},
    {"name": "Consoles and Video Games", "icon": ""},
    {"name": "Jobs", "icon": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Select Category for Ad Listing',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectSubCategory()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/svg/Logo/splashlogo.png'),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      categories[index]["name"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
