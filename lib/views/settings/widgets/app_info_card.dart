import 'package:flutter/material.dart';

class AppInfoBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context), // tap outside closes
      child: Container(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {}, // prevent inside tap closing
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

                      // Drag handle
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

                      // Title
                      Text(
                        "App Information",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 16),

                      // -------- Version --------
                      _sectionTitle("Version"),
                      _sectionText("v2.0.0"),
                      _sectionText("Build Number: 25"),

                      SizedBox(height: 12),

                      _sectionTitle("Developed by"),
                      _sectionText("ProjexHub Team"),
                      _sectionText("Made with ❤️ in India 🇮🇳"),

                      Divider(color: Colors.white24, height: 30),

                      // -------- Device Info --------
                      _sectionTitle("Device Information"),
                      _sectionText("Device: Android / iOS"),
                      _sectionText("OS Version: Android 14 / iOS 17"),
                      _sectionText("App Platform: Flutter"),

                      Divider(color: Colors.white24, height: 30),

                      // -------- Status --------
                      _sectionTitle("App Status"),
                      _statusRow("Server Status", "🟢 Online"),
                      _statusRow("Database", "🟢 Connected"),
                      _statusRow("API Response", "🟢 Working"),

                      Divider(color: Colors.white24, height: 30),

                      // -------- Support --------
                      _sectionTitle("Support"),
                      _sectionText(
                          "Facing issues? Contact us at:\nsupport@projexhub.com"),


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
      padding: EdgeInsets.only(bottom: 6),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _statusRow(String title, String status) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white70)),
          Text(status, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }


}