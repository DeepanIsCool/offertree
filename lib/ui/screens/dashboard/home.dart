import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/screens/ads/private/ad_details.dart';
import 'package:offertree/ui/screens/category/subcategory.dart';
import 'package:offertree/ui/components/bottomnav.dart';
import 'package:offertree/ui/components/slider.dart';
import 'package:offertree/ui/components/infinitecards.dart';
import 'package:offertree/ui/screens/search/search_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> infiniteItems = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchInfiniteItems();
    _fetchCategories();
  }

  List<Map<String, dynamic>> categoryList = [];
  bool isCategoryLoading = true;

  Future<void> _fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://offertree-backend.vercel.app/api/category'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categoryList = data.map<Map<String, dynamic>>((category) {
          return {
            'label': category['name'],
            'image': Image.asset('assets/house.png'),
            'destination': Subcategory(
              categoryId: category['id'],
              name: category['name'],
            ),
          };
        }).toList();
        isCategoryLoading = false;
      });
    } else {
      setState(() {
        isCategoryLoading = false;
      });
      throw Exception('Failed to load categories');
    }
  }

  Future<void> _fetchInfiniteItems() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://offertree-backend.vercel.app/api/ads'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> newItems = json.decode(response.body);
      setState(() {
        infiniteItems =
            newItems.map((item) => item as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load items');
    }
  }

  Future<List<dynamic>> fetchAdsFromApi() async {
    final response = await http.get(
      Uri.parse('https://offertree-backend.vercel.app/api/ads'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ads');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OfferTree',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Iconsax.user_octagon,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                HomeSearchField(),
                SliderWidget(imageUrls: [
                  'assets/svg/Illustrators/onbo_a.png',
                  'assets/svg/Illustrators/onbo_b.png',
                  'assets/svg/Illustrators/onbo_c.png',
                ]),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: isLoading
                        ? List.generate(
                            3, (index) => _buildCategoryItemShimmer())
                        : categoryList.map<Widget>((category) {
                            return _buildCategoryItem(
                              image: category['image'],
                              label: category['label'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        category['destination'],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Popular Properties'),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: isLoading
                        ? List.generate(
                            9, (index) => _buildPropertyCardShimmer())
                        : [
                            _buildPropertyCards(),
                            _buildPropertyCards(),
                            _buildPropertyCards(),
                          ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('More Items'),
                const SizedBox(height: 16),
                GestureDetector(
                    onTap: () {},
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: infiniteItems.length,
                      itemBuilder: (context, index) {
                        return buildInfiniteCard(context, infiniteItems[index]);
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

//Property Cards
  Widget _buildPropertyCards() {
    return FutureBuilder<List<dynamic>>(
      future: fetchAdsFromApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display shimmer cards while loading
          return Row(
            children: List.generate(3, (index) => _buildPropertyCardShimmer()),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No ads available'));
        }

        final ads = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ads.map<Widget>((ad) {
              bool isLiked = false;
              return GestureDetector(
                onTap: () {
                  int adId = (ad['id']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdDetails(
                        adId,
                        id: adId,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.asset(
                              'assets/svg/Illustrators/onbo_c.png',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: () {
                                // Toggle "like" status
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              child: Icon(
                                Iconsax.heart5,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${ad["price"]}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF576bd6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ad["title"],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.location,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ad["location"],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

//Property Shimmer
  Widget _buildPropertyCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 80,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//Category Item
  Widget _buildCategoryItem({
    required Image image,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF576bd6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: image,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

//Category Shimmer
  Widget _buildCategoryItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 40,
                height: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 50,
              height: 10,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

//Section Header
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF576bd6),
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('See All'),
        ),
      ],
    );
  }
}

//infinitecard Shimmer
Widget buildInfiniteCardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Placeholder
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Placeholder
                  Container(
                    width: 80,
                    height: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  // Title Placeholder
                  Container(
                    width: 120,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  // Location Placeholder
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Heart Icon Placeholder
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
