import 'dart:convert';
import 'lib/models/project_response.dart';

void main() {
  String jsonData = '''[
    {
        "_id": "69cd8f1bf3090d6f3567b2c4",
        "title": "Attendance System ",
        "description": "...",
        "status": "rejected",
        "createdAt": "2026-04-01T21:33:15.542Z",
        "image": "https://res.cloudinary.com/dwv7t8jvx/image/upload/v1775079162/smrjhfsxmss7djno9b0y.jpg",
        "score": 0.8264024257659912
    }
  ]''';
  List data = jsonDecode(jsonData);
  var parsed = ProjectResponse.fromJson(data[0] as Map<String, dynamic>);
  print("Status parsed: '" + parsed.status + "'");
  print("Images parsed: " + parsed.images.toString());
}
