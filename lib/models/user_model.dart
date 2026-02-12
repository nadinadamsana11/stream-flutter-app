import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? displayName;
  final String? bio;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.displayName,
    this.bio,
    this.photoUrl,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'],
      bio: data['bio'],
      // Fallback to UI Avatars if no photo exists, matching app.js logic
      photoUrl: data['photoUrl'] ?? 
          "https://ui-avatars.com/api/?name=${data['username']}&background=1c62b9&color=fff&size=128",
    );
  }
}