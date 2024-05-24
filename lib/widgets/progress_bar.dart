import 'package:flutter/material.dart';
import 'package:surveys_app_project/colors.dart';

class ProgressBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  ProgressBar({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        bool isSelected = currentPage == index + 1;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            radius: isSelected ? 15 : 5,
            backgroundColor: isSelected ? AppColors.facebookBlue : Colors.grey,
            child: isSelected
                ? Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        );
      }),
    );
  }
}
