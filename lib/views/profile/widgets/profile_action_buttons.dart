import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../common/app_style.dart';
import '../../../constants/links.dart';
import '../../../controllers/login_controller.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  void _showUpdateProfileBottomSheet(BuildContext context, LoginController loginController) {
    var user = loginController.getUserInfo();
    TextEditingController usernameController = TextEditingController(text: user?.userName ?? '');
    TextEditingController emailController = TextEditingController(text: user?.email ?? '');
    TextEditingController roleController = TextEditingController(text: user?.role ?? '');
    TextEditingController bioController = TextEditingController(text: user?.bio ?? '');

    File? selectedImage;
    bool isUploading = false;
    String profileUrl = user?.profile ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            
            Future<void> pickImage() async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  selectedImage = File(image.path);
                });
              }
            }

            Future<String?> uploadToCloudinary(File imageFile) async {
              try {
                Uri url = Uri.parse(cloudinaryUploadUrl);
                var request = http.MultipartRequest("POST", url);
                request.fields['upload_preset'] = cloudinaryUploadPreset;
                request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

                var streamedResponse = await request.send();
                var response = await http.Response.fromStream(streamedResponse);

                if (response.statusCode == 200) {
                  var data = jsonDecode(response.body);
                  return data['secure_url'];
                } else {
                  debugPrint("Cloudinary upload failed: ${response.body}");
                }
              } catch (e) {
                debugPrint("Cloudinary upload error: $e");
              }
              return null;
            }

            void handleUpdate() async {
              setState(() {
                isUploading = true;
              });

              if (selectedImage != null) {
                String? newUrl = await uploadToCloudinary(selectedImage!);
                if (newUrl != null) {
                  profileUrl = newUrl;
                } else {
                  setState(() {
                    isUploading = false;
                  });
                  Get.snackbar("Upload Failed", "Could not upload image", backgroundColor: Colors.redAccent, colorText: Colors.white);
                  return;
                }
              }
              
              await loginController.updateProfile(
                username: usernameController.text,
                email: emailController.text,
                profile: profileUrl,
                role: roleController.text,
                bio: bioController.text,
              );

              setState(() {
                isUploading = false;
              });
              
              Navigator.pop(context);
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20.w,
                right: 20.w,
                top: 20.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Edit Profile", style: appStyle(18, Colors.white, FontWeight.bold)),
                    SizedBox(height: 20.h),
                    
                    // Profile Image Picker
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: selectedImage != null 
                            ? FileImage(selectedImage!) as ImageProvider 
                            : (profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null),
                        child: selectedImage == null && profileUrl.isEmpty
                            ? Icon(Icons.person, size: 50.r, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text("Tap to change picture", style: appStyle(12, Colors.grey, FontWeight.normal)),
                    SizedBox(height: 20.h),
                
                    // Username Field
                    TextField(
                      controller: usernameController,
                      style: appStyle(14, Colors.white, FontWeight.normal),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: appStyle(14, Colors.grey, FontWeight.normal),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700), borderRadius: BorderRadius.circular(10.r)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF0F52FF)), borderRadius: BorderRadius.circular(10.r)),
                      ),
                    ),
                    SizedBox(height: 15.h),
                
                    // Email Field
                    TextField(
                      controller: emailController,
                      style: appStyle(14, Colors.white, FontWeight.normal),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: appStyle(14, Colors.grey, FontWeight.normal),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700), borderRadius: BorderRadius.circular(10.r)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF0F52FF)), borderRadius: BorderRadius.circular(10.r)),
                      ),
                    ),SizedBox(height: 15.h),
                
                    // Email Field
                    TextField(
                      controller: roleController,
                      style: appStyle(14, Colors.white, FontWeight.normal),
                      decoration: InputDecoration(
                        labelText: "Role",
                        labelStyle: appStyle(14, Colors.grey, FontWeight.normal),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700), borderRadius: BorderRadius.circular(10.r)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF0F52FF)), borderRadius: BorderRadius.circular(10.r)),
                      ),
                    ),SizedBox(height: 15.h),
                
                    // Email Field
                    TextField(
                      controller: bioController,
                      maxLines: 5,
                      style: appStyle(14, Colors.white, FontWeight.normal),
                      decoration: InputDecoration(
                        labelText: "Bio",
                        labelStyle: appStyle(14, Colors.grey, FontWeight.normal),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700), borderRadius: BorderRadius.circular(10.r)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF0F52FF)), borderRadius: BorderRadius.circular(10.r)),
                      ),
                    ),
                    SizedBox(height: 30.h),
                
                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: isUploading ? null : handleUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F52FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          disabledBackgroundColor: Colors.grey.shade800,
                        ),
                        child: isUploading 
                            ? SizedBox(height: 20.h, width: 20.h, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text("Update", style: appStyle(16, Colors.white, FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();

    return Row(
      children: [
        // Primary 'Edit Profile' Button
        Expanded(
          child: GestureDetector(
            onTap: () => _showUpdateProfileBottomSheet(context, loginController),
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0F52FF), // Vivid blue
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F52FF).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  "Edit Profile",
                  style: appStyle(16, Colors.white, FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1E1E2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                title: Text(
                  "Delete Account",
                  style: appStyle(18, Colors.white, FontWeight.bold),
                ),
                content: Text(
                  "Are you sure you want to delete your account? This action cannot be undone.",
                  style: appStyle(14, Colors.grey, FontWeight.normal),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: appStyle(14, Colors.white, FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      loginController.deleteUser();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Delete",
                      style: appStyle(14, Colors.red, FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(Icons.delete, color: Colors.red[400]),
            ),
          ),
        ),
      ],
    );
  }
}

