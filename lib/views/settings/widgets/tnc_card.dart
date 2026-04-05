import 'package:flutter/material.dart';

class TermsAndConditionsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF13131A),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      Text(
                        "Terms of Service – ProjexHub",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Last Updated: 04-04-2026",
                        style: TextStyle(color: Colors.white60),
                      ),

                      SizedBox(height: 16),

                      _sectionTitle("1. User Responsibilities"),
                      _sectionText(
                          "- You must provide accurate information.\n"
                          "- You are responsible for your account activity."),

                      _sectionTitle("2. Content Rules"),
                      _sectionText(
                          "You agree NOT to upload:\n"
                          "- Harmful, illegal, or offensive content.\n"
                          "- Plagiarized or copyrighted material without permission.\n"
                          "- Spam or misleading projects."),

                      _sectionTitle("3. Project Ownership"),
                      _sectionText(
                          "- You retain ownership of your content.\n"
                          "- By uploading, you grant ProjexHub permission to display your content."),

                      _sectionTitle("4. Account Termination"),
                      _sectionText(
                          "- We reserve the right to suspend or delete accounts that violate rules."),

                      _sectionTitle("5. Service Availability"),
                      _sectionText(
                          "- We strive to keep the app running smoothly but do not guarantee uninterrupted service."),

                      _sectionTitle("6. Limitation of Liability"),
                      _sectionText(
                          "- ProjexHub is not responsible for any data loss or damages."),

                      _sectionTitle("7. Changes to Terms"),
                      _sectionText(
                          "- Terms may be updated at any time."),

                      _sectionTitle("8. Contact"),
                      _sectionText(
                          "For any issues, contact:\n"
                          "projexhubmail@gmail.com"),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}