import 'package:fintech_app/presentation/widgets/news_widget.dart';
import 'package:flutter/material.dart';
// Import the separate widget file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: NewsCarousel(
            images: [
              "https://picsum.photos/2000/3000",
              "https://picsum.photos/2000/3000",
              "https://picsum.photos/2000/3000",
            ],
          ),
        ),
      ),
    );
  }
}
