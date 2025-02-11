import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class InitialView extends StatefulWidget {
  final VoidCallback onSignUpClicked;
  final VoidCallback onSignInClicked;

  const InitialView({
    super.key,
    required this.onSignUpClicked,
    required this.onSignInClicked,
  });

  @override
  _InitialViewState createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> with WidgetsBindingObserver  {
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
  final CarouselSliderController _controller =CarouselSliderController();
  bool _isAutoScrolling = false;
  Timer? _autoScrollTimer; // Add this class variable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    //_startAutoScroll();//starts th frame directly
    // Start auto-scrolling after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isAutoScrolling=true;
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
    if (state == AppLifecycleState.resumed) {
      // App has returned to the foreground
     _isAutoScrolling=true;
      _startAutoScroll();
    } else if (state == AppLifecycleState.paused) {
      // App has gone into the background
      _stopAutoScroll();
    }
  }
  void _stopAutoScroll() {
    _isAutoScrolling = false;
    _autoScrollTimer?.cancel(); // Cancel any existing timer
    _autoScrollTimer = null;
  }
  void _startAutoScroll() {
    if (_isAutoScrolling && mounted) {
      //_isAutoScrolling = true;
      _autoScrollTimer = Timer(const Duration(seconds: 3), () {
        if (_isAutoScrolling && mounted ) {
          final nextPage = (_current + 1) % imagePaths.length;
          if( _controller != null){
            _controller.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
          _startAutoScroll();
        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //Expanded(//takes up the remaining space from the column widget
            Flexible(
              flex: 7,
              // Image Carousel
              child:CarouselSlider(
                items: imagePaths.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
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
                                  imagePath,
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
                                    imageTexts[_current],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: false, // Auto-scroll handled manually
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
          ),
            // Dots Indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: DotsIndicator(
            dotsCount: imagePaths.length,
            position:_current,//(_current + 1) % imagePaths.length,  // Shift the position dynamically
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

        Flexible(
          flex:2,
        // Sign-Up Button
        child:SizedBox(//sets a fix shape to the element in it regardless of everything
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
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ),

        const SizedBox(height: 16.0),
        Flexible(
          flex:2,
        // Sign-In Button
        child:SizedBox(
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
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
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
