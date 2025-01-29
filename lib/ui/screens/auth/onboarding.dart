import 'package:flutter/material.dart';
import 'package:offertree/ui/screens/auth/login/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPageIndex = 0;
  double currentSwipe = 0;
  late int totalPages;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> slidersList = [
      {
        'svg': "assets/svg/Illustrators/onbo_a.png",
        'title': "Post Ads Instantly",
        'description': "Easily create and publish ads in just a few clicks, reaching your audience quickly and efficiently",
      },
      {
        'svg': "assets/svg/Illustrators/onbo_b.png",
        'title': "Find What You Need",
        'description': "Discover products, services, or opportunities tailored to your needs with ease.",
      },
      {
        'svg': "assets/svg/Illustrators/onbo_c.png",
        'title': "Chat Securely",
        'description': "Communicate with confidence using end-to-end encryption to protect your conversations.",
      },
    ];

    totalPages = slidersList.length;
    double heightFactor = 0.79;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: screenHeight * (heightFactor + 0.05),
              ),
              Positioned(
                child: CustomPaint(
                  isComplex: true,
                  size: Size(
                    screenWidth,
                    screenHeight * heightFactor,
                  ),
                  painter: BottomCurvePainter(),
                ),
              ),
              Positioned(
                top: 74,
                child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    currentSwipe = details.localPosition.direction;
                    setState(() {});
                  },
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (currentSwipe < 0.9) {
                      if (currentPageIndex > 0) {
                        setState(() {
                          currentPageIndex--;
                        });
                      }
                    } else {
                      if (currentPageIndex < slidersList.length - 1) {
                        setState(() {
                          currentPageIndex++;
                        });
                      }
                    }
                  },
                  child: SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 60),
                          SizedBox(
                            width: screenWidth,
                            height: 221,
                            child: Image.asset(
                              slidersList[currentPageIndex]['svg']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 39),
                          Text(
                            slidersList[currentPageIndex]['title']!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Text(
                              slidersList[currentPageIndex]['description']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 24),
                          IndicatorBuilder(
                            total: totalPages,
                            selectedIndex: currentPageIndex,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * ((0.636 * heightFactor) / 0.7),
                left: (screenWidth / 2) - 35,
                child: GestureDetector(
                  onTap: () {
                    if (currentPageIndex < slidersList.length - 1) {
                      setState(() {
                        currentPageIndex++;
                      });
                    } else {
                      setState(() {
                        currentPageIndex--;
                      });
                    }
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFF576bd6),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF576bd6).withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                          spreadRadius: 2,
                        )
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      currentPageIndex < slidersList.length - 1 ? Icons.arrow_forward : Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              height: 56,
              minWidth: 201,
              color: Color(0xFF576bd6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                currentPageIndex < slidersList.length - 1 ? "Sign In" : "Get Started",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IndicatorBuilder extends StatelessWidget {
  final int total;
  final int selectedIndex;

  const IndicatorBuilder({
    super.key,
    required this.total,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: selectedIndex == index ? 24 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: Color(0xFF576bd6),
              borderRadius: BorderRadius.circular(6),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 7);
        },
        itemCount: total,
      ),
    );
  }
}

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    Path path = Path();

    path.lineTo(0, 0);
    path.cubicTo(0, 0, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, size.width * 0.26, size.height, size.width * 0.26, size.height);
    path.cubicTo(size.width * 0.35, size.height, size.width * 0.36, size.height * 0.98, size.width * 0.38, size.height * 0.95);
    path.cubicTo(size.width * 0.38, size.height * 0.94, size.width * 0.41, size.height * 0.89, size.width / 2, size.height * 0.89);
    path.cubicTo(size.width * 0.58, size.height * 0.89, size.width * 0.6, size.height * 0.93, size.width * 0.61, size.height * 0.94);
    path.cubicTo(size.width * 0.63, size.height * 0.97, size.width * 0.63, size.height, size.width * 0.72, size.height);
    path.cubicTo(size.width * 0.72, size.height, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, 0, 0, 0, 0);

    canvas.drawShadow(
      path,
      Colors.grey.withOpacity(0.1),
      6.0,
      true,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}