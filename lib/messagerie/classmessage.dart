import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final List<String> images;
  final List<String> videos;
  final List<Map<String, dynamic>> documents;
  final String senderId; // Nouveau champ pour l'ID de l'expéditeur

  Message({
    required this.text,
    required this.images,
    required this.videos,
    required this.documents,
    required this.senderId,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          senderId == other.senderId &&
          listEquals(images, other.images) &&
          listEquals(videos, other.videos) &&
          listEquals(documents, other.documents);

  @override
  int get hashCode =>
      text.hashCode ^
      senderId.hashCode ^
      images.hashCode ^
      videos.hashCode ^
      documents.hashCode;
}
