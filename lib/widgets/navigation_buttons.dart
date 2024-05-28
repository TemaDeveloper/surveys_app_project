import 'package:flutter/material.dart';
import 'package:surveys_app_project/colors.dart';

class NavigationButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isAnswerSelected;
  final bool isNextButtonEnabled;
  final VoidCallback onSubmit; // Add onSubmit callback

  NavigationButtons({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    required this.isAnswerSelected,
    required this.isNextButtonEnabled,
    required this.onSubmit, // Initialize onSubmit
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
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isNextButtonEnabled ? AppColors.facebookBlue : Colors.orange,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(25.0),
                color: isNextButtonEnabled ? AppColors.facebookBlue : Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: ElevatedButton(
                  onPressed: isNextButtonEnabled
                      ? currentPage == totalPages - 1
                          ? onSubmit // Call onSubmit instead of navigating directly
                          : onNext
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  ),
                  child: Text(
                    currentPage == totalPages - 1 ? 'Finish' : 'Next',
                    style: TextStyle(
                      color: isNextButtonEnabled ? Colors.white : AppColors.facebookBlue,
                      fontSize: 18,
                      fontFamily: 'arial_rounded'
                    ),
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
