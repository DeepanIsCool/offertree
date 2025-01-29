import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:offertree/ui/screens/ads/private/ad_details.dart';
import 'package:offertree/ui/screens/category/categorylist.dart';
import 'package:offertree/ui/screens/category/subcategory.dart';
import 'package:offertree/ui/components/bottomnav.dart';
import 'package:offertree/ui/components/slider.dart';
import 'package:offertree/ui/components/infinitecards.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> infiniteItems = [];
  bool isLoading = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadMoreData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 1));

    final newItems = List.generate(1, (index) => {
      'price': 750.00 + (index * 100),
      'title': 'Item ${infiniteItems.length + index + 1}',
      'location': 'Bhuj, Gujarat, India'
    });

    setState(() {
      infiniteItems.addAll(newItems);
      currentPage++;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                    Icon(Iconsax.location,
                      color: Color(0xFF576bd6),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Bhuj, Gujarat, India',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SliderWidget(imageUrls:
                [
                  'https://picsum.photos/id/237/200/300',
                  'https://picsum.photos/seed/picsum/200/300',
                  'https://picsum.photos/200/300?grayscale',
                ]),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryItem(
                        icon: Iconsax.home,
                        label: 'Home',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Subcategory(),
                            ),
                          );
                        },
                      ),
                      _buildCategoryItem(
                        icon: Iconsax.coffee,
                        label: 'Furnitures',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Subcategory(),
                            ),
                          );
                        },
                      ),
                      _buildCategoryItem(
                        icon: Iconsax.cloud,
                        label: 'Clothing',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Subcategory(),
                            ),
                          );
                        },
                      ),
                      _buildCategoryItem(
                        icon: Iconsax.pet,
                        label: 'Pets',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Subcategory(),
                            ),
                          );
                        },
                      ),
                      _buildCategoryItem(
                        icon: Iconsax.car,
                        label: 'Vehicles',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Subcategory(),
                            ),
                          );
                        },
                      ),
                      _buildCategoryItem(
                        icon: Iconsax.monitor,
                        label: 'Electronic',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Subcategory(),
                            ),
                          );
                        },
                      ),
                      _buildCategoryItem(
                        icon: Iconsax.more_square,
                        label: 'All',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Properties Section
                _buildSectionHeader('Popular Properties'),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPropertyCard(),
                      _buildPropertyCard(),
                      _buildPropertyCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Electronics Section
                _buildSectionHeader('Popular in Electronics'),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildWatchCard(
                        'Rolex submari',
                        1249.00,
                      ),
                      _buildWatchCard(
                        'Omega speed',
                        1900.00,
                      ),
                      _buildWatchCard(
                        'Tag heuer',
                        2599.00,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('More Items'),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: infiniteItems.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == infiniteItems.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return buildInfiniteCard(context, infiniteItems[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildPropertyCard() {
    bool isLiked = false;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdDetails(),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                  '\$750.00',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF576bd6),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Villa',
                  style: TextStyle(
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
                      'Bhuj,Gujarat,India',
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
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  })
  {
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
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
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

  Widget _buildWatchCard(String title, double price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdDetails(),
          ),
        );
      },
    child: Container(
      width: 180,
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  'assets/svg/Illustrators/onbo_b.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  Iconsax.heart5,
                  color: Colors.redAccent,
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
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF576bd6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
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
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Bhuj,Gujarat,India',
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
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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