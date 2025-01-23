import 'package:flutter/material.dart';

class Subcategory extends StatelessWidget {
  final List<ApplianceItem> appliances = [
    ApplianceItem(
      icon: Icon(Icons.cloud),
      title: 'Refrigerators & Freezers',
    ),
    ApplianceItem(
      icon: Icon(Icons.cloud),
      title: 'Air Conditioners',
    ),
    ApplianceItem(
      icon: Icon(Icons.cloud),
      title: 'Washing Machines',
    ),
    ApplianceItem(
      icon: Icon(Icons.cloud),
      title: 'Water Coolers',
    ),
    ApplianceItem(
      icon: Icon(Icons.cloud),
      title: 'Fryers',
    ),
    ApplianceItem(
      icon: Icon(Icons.cloud),
      title: 'Hot Plates & Grills',
    ),
    ApplianceItem(
      icon: Icon(Icons.cloud),
      title: 'Other',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Home appliances',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'All Home appliances',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: appliances.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/svg/Logo/splashlogo.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  title: Text(
                    appliances[index].title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
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
                    // Handle navigation
                  },
                );
              },
            ),
          ),
        ],
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