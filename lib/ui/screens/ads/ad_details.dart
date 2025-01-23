import 'package:flutter/material.dart';
import 'package:offertree/ui/components/slider.dart';

class VillaDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("\$750.00"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
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
              color: Colors.teal,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
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
                  buildFeatureTile(Icons.bed, "3 Bedrooms"),
                  buildFeatureTile(Icons.bathtub, "2 Bathrooms"),
                  buildFeatureTile(Icons.aspect_ratio, "5000 Carpet Area"),
                  buildFeatureTile(Icons.home_work, "75000 Built-Up Area"),
                  buildFeatureTile(Icons.event_seat, "Unfurnished"),
                  buildFeatureTile(Icons.balcony, "Balconies: Yes"),
                  buildFeatureTile(Icons.local_parking, "Parking: Yes"),
                  buildFeatureTile(Icons.check_circle, "Ready to Move"),
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
                    "About this item",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Villa on rent",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Contact Section
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text("Designer"),
              subtitle: Text("demo@gmail.com"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.mark_chat_unread, color: Colors.teal),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.phone_android_rounded, color: Colors.teal),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Location Section
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
                  backgroundColor: Colors.teal,
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

  Widget buildFeatureTile(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        SizedBox(width: 8),
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
