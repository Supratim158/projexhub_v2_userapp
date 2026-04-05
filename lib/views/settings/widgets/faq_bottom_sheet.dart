import 'package:flutter/material.dart';

class FAQBottomSheet extends StatefulWidget {
  @override
  _FAQBottomSheetState createState() => _FAQBottomSheetState();
}

class _FAQBottomSheetState extends State<FAQBottomSheet> {
  int? expandedIndex;

  final List<Map<String, String>> faqs = [
  {
    "question": "How to upload a project?",
    "answer": "Go to upload → fill details → submit."
  },
  {
    "question": "Is ProjexHub free?",
    "answer": "Yes, completely free."
  },
  {
    "question": "Can I edit my project?",
    "answer": "Yes, go to your profile → tap on 3 dots in the project → edit project."
  },
  {
    "question": "Can I delete my project?",
    "answer": "Yes, go to your profile → tap on 3 dots in the project → delete."
  },
  {
    "question": "What file types are supported for uploads?",
    "answer": "You can upload images, videos, and PDF reports."
  },
  {
    "question": "Why is my project not visible after uploading?",
    "answer": "It will be sent to the Admin for approval , after approval it will be visible, you can track the status in status page."
  },
  {
    "question": "Can I upload multiple images for a project?",
    "answer": "Yes, you can upload multiple images."
  },
  {
    "question": "How do I update my profile?",
    "answer": "Go to profile → edit profile."
  },
  {
    "question": "I didn’t receive OTP. What should I do?",
    "answer": "Check spam folder or wait a few seconds and try again."
  },
  {
    "question": "How do I contact support?",
    "answer": "Mail on this mail projexhubmail@gmail.com."
  },
  {
    "question": "Is my data secure?",
    "answer": "Yes, we use secure authentication and do not share your data."
  },
  {
    "question": "Can I see other users’ projects?",
    "answer": "Yes, browse projects from the homepage."
  },
  {
    "question": "How do I report a bug?",
    "answer": "Go to settings → support → send feedback."
  },
  {
    "question": "Can I save or bookmark projects?",
    "answer": "This feature will be available soon."
  },
  {
    "question": "What should I do if the app is slow?",
    "answer": "Check your internet connection or restart the app."
  },
  {
    "question": "Is ProjexHub available on web?",
    "answer": "Coming soon."
  },
  {
    "question": "Who can use ProjexHub?",
    "answer": "Students, developers, and creators can use it."
  },
  {
    "question": "What happens if I upload inappropriate content?",
    "answer": "It may be removed and your account can be restricted."
  },
];

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pop(context), // 👈 tap outside closes
    child: Container(
      color: Colors.black54, // 👈 dim background
      child: GestureDetector(
        onTap: () {}, // 👈 prevent closing when tapping inside
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF13131A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView.builder(
                controller: controller,
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final item = faqs[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedIndex =
                                expandedIndex == index ? null : index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item["question"]!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                expandedIndex == index
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),

                      if (expandedIndex == index)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            item["answer"]!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      Divider(color: Colors.white24),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    ),
  );
}
}