import 'package:flutter/material.dart';

class PrivacyPolicyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context), // tap outside closes
      child: Container(
        color: Colors.black54, // dim background
        child: GestureDetector(
          onTap: () {}, // prevent closing when tapping inside
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
                      // Drag Handle
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
                        "Privacy Policy – ProjexHub",
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

                      _sectionTitle("1. Information We Collect"),
                      _sectionText(
                          "- Personal Information: Name, email address, and profile details.\n"
                          "- Project Data: Title, description, images, videos, and documents uploaded by you.\n"
                          "- Usage Data: App interactions, device information, and log data."),

                      _sectionTitle("2. How We Use Your Information"),
                      _sectionText(
                          "- To create and manage your account.\n"
                          "- To display your projects on the platform.\n"
                          "- To improve app performance and user experience.\n"
                          "- To communicate with you (OTP, notifications, support)."),

                      _sectionTitle("3. Data Sharing"),
                      _sectionText(
                          "- We do NOT sell or share your personal data with third parties.\n"
                          "- Your uploaded projects are publicly visible to other users."),

                      _sectionTitle("4. Data Security"),
                      _sectionText(
                          "- We use secure authentication and encryption methods.\n"
                          "- Your data is stored securely in our database."),

                      _sectionTitle("5. Your Rights"),
                      _sectionText(
                          "- You can edit or delete your data anytime.\n"
                          "- You can request account deletion."),

                      _sectionTitle("6. Cookies & Tracking"),
                      _sectionText(
                          "- We may use basic tracking for improving performance."),

                      _sectionTitle("7. Changes to Policy"),
                      _sectionText(
                          "- We may update this policy. Users will be notified of major changes."),

                      _sectionTitle("8. Contact Us"),
                      _sectionText(
                          "If you have any questions, contact us at:\n"
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