import 'package:app/constants/constants.dart';
import 'package:app/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordBottomSheet extends StatefulWidget {
  const PasswordBottomSheet({super.key});

  @override
  State<PasswordBottomSheet> createState() => _PasswordBottomSheetState();
}

class _PasswordBottomSheetState extends State<PasswordBottomSheet> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;

  // ✅ Get Controller
  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E2C),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Drag Handle
                  Center(
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Title
                  const Text(
                    "Password & Security",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Current Password
                  TextField(
                    controller: currentPasswordController,
                    obscureText: obscureCurrent,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureCurrent ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureCurrent = !obscureCurrent;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔹 New Password
                  TextField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNew ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureNew = !obscureNew;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔥 Button with Loading (Merged)
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: loginController.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  String current =
                                      currentPasswordController.text.trim();
                                  String newPass =
                                      newPasswordController.text.trim();

                                  // ✅ Validation
                                  if (current.isEmpty || newPass.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please fill all fields"),
                                      ),
                                    );
                                    return;
                                  }

                                  if (newPass.length < 6) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Password must be at least 6 characters"),
                                      ),
                                    );
                                    return;
                                  }

                                  // 🚀 CALL API
                                  await loginController.changePassword(
                                    currentPassword: current,
                                    newPassword: newPass,
                                  );

                                  // ✅ Clear fields
                                  currentPasswordController.clear();
                                  newPasswordController.clear();

                                  // ✅ Close sheet
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Update Password",
                                  style: TextStyle(fontSize: 16, color: kWhite),
                                ),
                              ),
                      )),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}