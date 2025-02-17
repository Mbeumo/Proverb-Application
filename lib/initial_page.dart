import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class InitialView extends StatefulWidget {
  final VoidCallback onSignUpClicked;
  final VoidCallback onSignInClicked;

  const InitialView({
    Key? key,
    required this.onSignUpClicked,
    required this.onSignInClicked,
  }) : super(key: key);

  @override
  _InitialViewState createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> with WidgetsBindingObserver {
  final List<String> imagePaths = [
    'assets/Firstpage/Bible image.jpeg',
    'assets/Firstpage/Bible 2.jpeg',
    'assets/Firstpage/read.jpeg',
  ];
  final List<String> imageTexts = [
    'Discover the Hidden Gems of Biblical Wisdom: Unearth the Power of Proverbs in Your Life.',
    'Unlock the Timeless Wisdom of Proverbs: Find Guidance for Every Step of Your Journey.',
    'Start Your Day with Divine Inspiration: Daily Proverbs to Uplift and Empower You.',
  ];

  int _current = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Start auto-scroll after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _stopAutoScroll();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause or resume auto scrolling based on app lifecycle changes.
    if (state == AppLifecycleState.resumed) {
      _startAutoScroll();
    } else if (state == AppLifecycleState.paused) {
      _stopAutoScroll();
    }
  }

  void _startAutoScroll() {
    _isAutoScrolling = true;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (mounted && _isAutoScrolling) {
        int nextPage = (_current + 1) % imagePaths.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _isAutoScrolling = false;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Carousel Slider Section
            Flexible(
              flex: 7,
              child: CarouselSlider.builder(
                itemCount: imagePaths.length,
                carouselController: _carouselController,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              imagePaths[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Container(
                              color: Colors.black45,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                imageTexts[index],
                                style: Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: false, // We handle auto-play manually
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    if (mounted) {
                      setState(() {
                        _current = index;
                      });
                    }
                  },
                ),
              ),
            ),
            // Dots Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DotsIndicator(
                dotsCount: imagePaths.length,
                position: _current,
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).primaryColor,
                  size: const Size.square(8.0),
                  activeSize: const Size(18.0, 8.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Sign Up Button
            Flexible(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: widget.onSignUpClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Sign In Button
            Flexible(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: widget.onSignInClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
