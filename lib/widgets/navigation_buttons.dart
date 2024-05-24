import 'package:flutter/material.dart';
import 'package:surveys_app_project/colors.dart';
import 'package:surveys_app_project/pages/finish_survey.dart';

class NavigationButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isAnswerSelected;
  final bool isNextButtonEnabled; // Track if the Next button should be enabled

  NavigationButtons({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    required this.isAnswerSelected,
    required this.isNextButtonEnabled, // Initialize isNextButtonEnabled
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
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubmissionSuccessScreen()),
                              );
                            }
                          : onNext
                      : null, // Disable button if not enabled
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .transparent, // Transparent to show the Container color
                    shadowColor: Colors.transparent, // Remove shadow if needed
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


