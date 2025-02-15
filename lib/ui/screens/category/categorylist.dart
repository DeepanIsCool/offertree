import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:offertree/ui/screens/category/subcategory.dart';

class CategoryList extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"name": "Home appliances", "icon": "https://via.placeholder.com/50"},
    {"name": "Furniture, ", "icon": "https://via.placeholder.com/50"},
    {
      "name": "Clothing & Accessories",
      "icon": "https://via.placeholder.com/50"
    },
    {"name": "Pets", "icon": "https://via.placeholder.com/50"},
    {"name": "Cars & Vehicles", "icon": "https://via.placeholder.com/50"},
    {"name": "Electronics", "icon": "https://via.placeholder.com/50"},
    {"name": "Cameras & Imaging", "icon": "https://via.placeholder.com/50"},
    {"name": "Jewelry & Watches", "icon": "https://via.placeholder.com/50"},
    {
      "name": "Mobile Phones & Tablets",
      "icon": "https://via.placeholder.com/50"
    },
    {
      "name": "Consoles and Video Games",
      "icon": "https://via.placeholder.com/50"
    },
    {"name": "Jobs", "icon": "https://via.placeholder.com/50"},
    {"name": "Musical Instruments", "icon": "https://via.placeholder.com/50"},
    {"name": "Musical Instruments", "icon": "https://via.placeholder.com/50"},
    {"name": "Musical Instruments", "icon": "https://via.placeholder.com/50"},
    {"name": "Musical Instruments", "icon": "https://via.placeholder.com/50"},
    {"name": "Musical Instruments", "icon": "https://via.placeholder.com/50"},
    {"name": "Musical Instruments", "icon": "https://via.placeholder.com/50"},
    {"name": "Musical Instruments", "icon": "https://via.placeholder.com/50"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Categories',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subcategory(
                    categoryId: 1,
                    name: 'Category',
                  ),
                ),
              );
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
