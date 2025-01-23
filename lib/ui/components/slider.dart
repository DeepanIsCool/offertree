import 'dart:async';
import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final List<String> imageUrls;

  const SliderWidget({Key? key, required this.imageUrls}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> _bannerIndex = ValueNotifier(0);
  late Timer _timer;
  final PageController _pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _startAutoSlider();
  }

  @override
  void dispose() {
    _bannerIndex.dispose();
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlider() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final int nextPage = _bannerIndex.value + 1;
      if (nextPage < widget.imageUrls.length) {
        _bannerIndex.value = nextPage;
      } else {
        _bannerIndex.value = 0;
      }
      _pageController.animateToPage(
        _bannerIndex.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<String> imagePaths = [
      'assets/svg/Illustrators/onbo_a.png',
      'assets/svg/Illustrators/onbo_b.png',
      'assets/svg/Illustrators/onbo_c.png',
    ];
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: widget.imageUrls.length,
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          _bannerIndex.value = index;
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePaths[index]),
            ),
          );
        },
      ),
    );
  }
}