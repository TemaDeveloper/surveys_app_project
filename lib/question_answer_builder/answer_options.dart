import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isMultipleChoice;
  final Function(String) onSelected;

  AnswerOption({
    required this.answer,
    required this.isSelected,
    required this.isMultipleChoice,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(answer),
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 24,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(answer),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.favorite, // Use a random icon here
                  color: isSelected ? Colors.white : Colors.grey[800],
                  size: 24.0,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            CircleAvatar(
              radius: 10,
              backgroundColor: isSelected ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}