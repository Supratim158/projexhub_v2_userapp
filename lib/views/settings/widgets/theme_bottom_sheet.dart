import 'package:flutter/material.dart';

class ThemeBottomSheet extends StatefulWidget {
  final String selectedTheme; // "dark", "light", "system"
  final Function(String) onThemeChanged;

  const ThemeBottomSheet({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  late String currentTheme;

  @override
  void initState() {
    super.initState();
    currentTheme = widget.selectedTheme;
  }

  Widget buildOption(String value, String title, IconData icon) {
    bool isSelected = currentTheme == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentTheme = value;
        });

        widget.onThemeChanged(value);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF1E1E2C),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔹 Drag Handle
                Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "Select Theme",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 20),

                buildOption("light", "Light Mode", Icons.light_mode),
                buildOption("dark", "Dark Mode", Icons.dark_mode),
                buildOption("system", "System Default", Icons.settings),
              ],
            ),
          ),
        );
      },
    );
  }
}