import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/components/slider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Ad {
  final int id;
  final String title;
  final String location;
  final String createdAt;
  final String description;
  final String mapsLocation;
  final String price;

  Ad({
    required this.id,
    required this.title,
    required this.location,
    required this.createdAt,
    required this.description,
    required this.mapsLocation,
    required this.price,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'],
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      createdAt: json['createdAt'] ?? '',
      description: json['description'] ?? '',
      mapsLocation: json['mapsLocation'] ?? '',
      price: json['price']?.toString() ?? '',
    );
  }
}

class AdDetails extends StatefulWidget {
  final int id;

  const AdDetails(ad, {Key? key, required this.id}) : super(key: key);

  @override
  _AdDetailsState createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  late Future<Ad> futureAd;

  @override
  void initState() {
    super.initState();
    futureAd = fetchAd(widget.id);
  }

  Future<Ad> fetchAd(int id) async {
    final response = await http
        .get(Uri.parse('https://offertree-backend.vercel.app/api/ads'));
    if (response.statusCode == 200) {
      final List adsList = json.decode(response.body);
      final adJson =
          adsList.firstWhere((ad) => ad['id'] == id, orElse: () => null);
      if (adJson != null) {
        return Ad.fromJson(adJson);
      } else {
        throw Exception("Ad not found");
      }
    } else {
      throw Exception("Failed to load ad");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ad>(
      future: futureAd,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final ad = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(ad.title,
                  style: Theme.of(context).textTheme.titleMedium),
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
                  // Top section with location and createdAt
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
                              ad.location,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ad.createdAt,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SliderWidget(imageUrls: [
                    'https://picsum.photos/id/237/200/300',
                    'https://picsum.photos/seed/picsum/200/300',
                    'https://picsum.photos/200/300?grayscale',
                  ]),
                  SizedBox(height: 16),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.title,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              ad.description,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Price Section
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
                          "₹ ${ad.price}",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Map Section using the mapsUrl
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
                    child: HtmlWidget(
                        '<iframe src="${ad.mapsLocation}"></iframe>'),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                icon: Icon(Iconsax.message,
                                    color: Color(0xFF576bd6)),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: Center(child: Text("No Data!")),
          );
        }
      },
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
