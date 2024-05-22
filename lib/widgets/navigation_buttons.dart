import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  NavigationButtons({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (currentPage > 0)
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onPrevious,
            ),
          ),
        Positioned(
          bottom: 16.0,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: onNext,
              child: Text(currentPage == totalPages - 1 ? 'Finish' : 'Next'),
            ),
          ),
        ),
      ],
    );
  }
}
