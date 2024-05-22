import 'package:flutter/material.dart';

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
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            radius: isSelected ? 15 : 10,
            backgroundColor: isSelected ? Colors.blue : Colors.grey,
            child: isSelected
                ? Text(
                    (index + 1).toString(),
                    style: TextStyle(
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
