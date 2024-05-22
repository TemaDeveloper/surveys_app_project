import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
    final bool isAnswerSelected;

  NavigationButtons({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    required this.isAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (currentPage > 0)
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: onPrevious,
              ),
            ),
          ),
        Positioned(
          bottom: 16.0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 50, // Match the height of the back button
              decoration: BoxDecoration(
                border: Border.all(
                  color: isAnswerSelected ? Colors.blue : Colors.orange,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(25.0),
                color: isAnswerSelected ? Colors.blue : Colors.white,
              ),
              child: TextButton(
                onPressed: onNext,
                child: Text(
                  currentPage == totalPages - 1 ? 'Finish' : 'Next',
                  style: TextStyle(
                    color: isAnswerSelected ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}