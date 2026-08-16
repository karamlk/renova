import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/project_provider_user.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class ReviewDialog extends StatefulWidget {
  final int assignmentId;

  const ReviewDialog({super.key, required this.assignmentId});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int selectedRating = 0;

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    if (selectedRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("يرجى اختيار تقييم")));
      return;
    }

    final provider = Provider.of<ProjectProviderUser>(context, listen: false);

    final response = await provider.submitRating(
      id: widget.assignmentId,
      rating: selectedRating,
      comment: commentController.text.trim(),
    );

    if (!mounted) return;

    final message = jsonDecode(response!.body);
    final result = message['message'] ?? ['error'];
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result, textAlign: TextAlign.right),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("تقييم المشروع", textAlign: TextAlign.right),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final rating = index + 1;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRating = rating;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      rating <= selectedRating ? Icons.star : Icons.star_border,
                      size: 32,
                      color: rating <= selectedRating ? Colors.amber : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            // Selected rating
            if (selectedRating > 0)
              Text(
                "$selectedRating / 5",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 16),

            // Comment
            TextField(
              controller: commentController,
              maxLines: 4,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                hintText: "اكتب تعليقاً",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),

      actions: [
        Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<ProjectProviderUser>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(60, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: context.watch<ThemeProvider>().isDark
                        ? Colors.white30
                        : primarycolor2,
                    foregroundColor: primarycolor1,
                  ),

                  onPressed: provider.isRating ? null : submitReview,
                  child: provider.isRating
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: primarycolor1),
                        )
                      : Text("تقييم", style: TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(60, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.white30
                    : primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "إلغاء",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
