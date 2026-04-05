// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
    String id;
    String title;
    String description;
    String status;
    DateTime createdAt;
    String image;
    double score;

    SearchResponse({
        required this.id,
        required this.title,
        required this.description,
        required this.status,
        required this.createdAt,
        required this.image,
        required this.score,
    });

    factory SearchResponse.fromJson(Map<String, dynamic> json) {
        // If the backend wraps the project details in a 'project' object
        final projectData = json["project"] ?? json;
        
        return SearchResponse(
            id: projectData["_id"] ?? json["_id"] ?? "",
            title: projectData["title"] ?? json["title"] ?? "",
            description: projectData["description"] ?? json["description"] ?? "",
            status: (projectData["status"] != null && projectData["status"].toString().isNotEmpty)
                ? projectData["status"].toString().toLowerCase()
                : (json["status"] != null && json["status"].toString().isNotEmpty)
                    ? json["status"].toString().toLowerCase()
                    : "pending",
            createdAt: projectData["createdAt"] != null 
                ? DateTime.parse(projectData["createdAt"]) 
                : (json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : DateTime.now()),
            image: projectData["image"] ?? json["image"] ?? (projectData["images"] != null && projectData["images"].isNotEmpty ? projectData["images"][0].toString() : ""),
            score: json["score"]?.toDouble() ?? 0.0,
        );
    }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "image": image,
        "score": score,
    };
}
