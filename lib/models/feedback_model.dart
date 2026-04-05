// To parse this JSON data, do
//
//     final feedbackModel = feedbackModelFromJson(jsonString);

import 'dart:convert';

FeedbackModel feedbackModelFromJson(String str) => FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

class FeedbackModel {
    String title;
    String feedback;

    FeedbackModel({
        required this.title,
        required this.feedback,
    });

    factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        title: json["title"],
        feedback: json["feedback"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "feedback": feedback,
    };
}
