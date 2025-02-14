import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/components/slider.dart';
class AdDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Sample Ad Name',
          style: Theme.of(context).textTheme.titleMedium,),
        actions: [
          IconButton(
            icon: Icon(Iconsax.export_1),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section
            Container(
              color: Color(0xFF576bd6),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.location, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Bhuj, Gujarat, India",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "8 May 2024",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SliderWidget(imageUrls:
            [
              'https://picsum.photos/id/237/200/300',
              'https://picsum.photos/seed/picsum/200/300',
              'https://picsum.photos/200/300?grayscale',
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3,
                ),
                children: [
                  buildFeatureTile("lorem ipsum"),
                ],
              ),
            ),
            SizedBox(height: 16),
            // About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "₹ 750.00 ",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Contact Section
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFF576bd6),
                child: Icon(Iconsax.user, color: Colors.white),
              ),
              title: Text("Designer"),
              subtitle: Text("demo@gmail.com"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Iconsax.message, color: Color(0xFF576bd6)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Iconsax.call, color: Color(0xFF576bd6)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Text(
                  "Google Map Placeholder",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF576bd6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                ),
                child: Text("Chat",
                  style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildFeatureTile(String label) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
