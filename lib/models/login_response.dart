// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String id;
  String userName;
  String email;
  String fcm;
  bool verification;
  String phone;
  bool phoneVerification;
  String userType;
  String profile;
  String userToken;
  String role;
  String bio;

  LoginResponse({
    required this.id,
    required this.userName,
    required this.email,
    required this.fcm,
    required this.verification,
    required this.phone,
    required this.phoneVerification,
    required this.userType,
    required this.profile,
    required this.userToken,
    required this.role,
    required this.bio,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    id: json["_id"] ?? "",
    userName: json["userName"] ?? json["username"] ?? "User",
    email: json["email"] ?? "",
    fcm: json["fcm"] ?? "",
    verification: json["verification"] ?? false,
    phone: json["phone"] ?? "",
    phoneVerification: json["phoneVerification"] ?? false,
    userType: json["userType"] ?? "",
    profile: json["profile"] ?? "",
    userToken: json["userToken"] ?? "",
    role: json["role"] ?? "",
    bio: json["bio"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
    "fcm": fcm,
    "verification": verification,
    "phone": phone,
    "phoneVerification": phoneVerification,
    "userType": userType,
    "profile": profile,
    "userToken": userToken,
    "role": role,
    "bio": bio
  };
}
