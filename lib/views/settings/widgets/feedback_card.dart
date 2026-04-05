import 'package:app/controllers/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackBottomSheet extends StatelessWidget {
  const FeedbackBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController feedbackController = TextEditingController();

    // ✅ Initialize controller
    final feedbackCtrl = Get.put(FeedbackController());

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                    "Send Feedback",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Title Field
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔹 Feedback Field
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Your Feedback",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Send Button with Loading
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: feedbackCtrl.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  String title = titleController.text.trim();
                                  String feedback =
                                      feedbackController.text.trim();

                                  if (title.isEmpty ||
                                      feedback.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Please fill all fields"),
                                      ),
                                    );
                                    return;
                                  }

                                  // 🚀 CALL API
                                  await feedbackCtrl.sendFeedback(
                                    title: title,
                                    feedback: feedback,
                                  );

                                  // ✅ Clear fields
                                  titleController.clear();
                                  feedbackController.clear();

                                  // ✅ Close bottom sheet
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Send Feedback",
                                  style: TextStyle(color: Colors.white),
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