import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> getImageUrl(String folder, String fileName) async {
  try {
    final Reference ref = FirebaseStorage.instance.ref().child(folder).child(fileName);
    String url = await ref.getDownloadURL();
    print("url = ${url}");
    return url;
  } catch (e) {
    print('Error getting image URL: $e');
    return '';
  }
}

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
            FutureBuilder<String>(
              future: getImageUrl(
                isSelected ? 'active_icons' : 'inactive_icons', 
                '${answer}_${isSelected ? "active" : "inactive"}.png' 
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Icon(Icons.broken_image);
                } else {
                  return Image.network(snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
