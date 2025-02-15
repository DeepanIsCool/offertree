import 'package:flutter/material.dart';
import 'package:offertree/ui/screens/ads/private/ad_create.dart';

class SelectSubCategory extends StatelessWidget {
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
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: appliances.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.transparent,
                thickness: 0.2,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  minTileHeight: 60,
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/svg/Logo/splashlogo.png',
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddItemDetails())
                    );
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