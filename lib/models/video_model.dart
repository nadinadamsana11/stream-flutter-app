import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String title;
  final String duration;
  final String thumbnailUrl;
  final String videoUrl;
  final String authorUid;
  final String authorName;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.authorUid,
    required this.authorName,
    required this.createdAt,
  });

  factory VideoModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoModel(
      id: doc.id,
      title: data['title'] ?? '',
      duration: data['duration'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      authorUid: data['authorUid'] ?? '',
      authorName: data['authorName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}