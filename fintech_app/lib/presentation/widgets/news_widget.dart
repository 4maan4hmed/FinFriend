import 'package:flutter/material.dart';
import 'dart:math' as math;

class NewsCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final Duration autoScrollDuration;

  const NewsCarousel({
    super.key, 
    required this.images,
    this.height = 250,
    this.autoScrollDuration = const Duration(seconds: 5),
  });

  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late AnimationController _indicatorAnimationController;
  
  @override
  void initState() {
    super.initState();
    _indicatorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    // Auto scroll feature
    if (widget.autoScrollDuration.inMilliseconds > 0) {
      Future.delayed(widget.autoScrollDuration, () {
        _autoScroll();
      });
    }
  }
  
  void _autoScroll() {
    if (!mounted) return;
    
    int nextPage = _currentPage + 1;
    if (nextPage >= widget.images.length) {
      nextPage = 0;
    }
    
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    
    Future.delayed(widget.autoScrollDuration, () {
      _autoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(
                  horizontal: 10, 
                  vertical: _currentPage == index ? 0 : 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _currentPage == index
                    ? [const BoxShadow(color: Colors.white38, blurRadius: 8, spreadRadius: 1)]
                    : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.images[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image, 
                                size: 50, 
                                color: Colors.grey
                              )
                            ),
                          );
                        },
                      ),
                      // Optional caption/overlay at the bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black87, Colors.transparent],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Image ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.info_outline, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        AnimatedDotsIndicator(
          dotsCount: widget.images.length,
          position: _currentPage,
          animationController: _indicatorAnimationController,
        ),
      ],
    );
  }
}

class AnimatedDotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;
  final AnimationController animationController;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedDotsIndicator({
    super.key,
    required this.dotsCount,
    required this.position,
    required this.animationController,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotsCount,
        (index) {
          final isActive = index == position;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: isActive
              ? _AnimatedDot(
                  controller: animationController,
                  color: activeColor,
                )
              : Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: inactiveColor,
                    shape: BoxShape.circle,
                  ),
                ),
          );
        },
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _AnimatedDot({
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        );
      },
    );
  }

  Widget _buildDot(int dotIndex) {
    final double offset = math.sin((controller.value * 2 * math.pi) - (dotIndex * 0.8));
    final double size = 3 + (offset + 1) * 3; // Oscillate between 3 and 9
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}