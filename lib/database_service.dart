import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/video_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserDoc(String uid, String email, String username, {String? displayName}) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'username': username,
      'email': email,
      'displayName': displayName ?? username,
      'createdAt': FieldValue.serverTimestamp(),
      'bio': '',
      'profileLink': '', // Placeholder
    });
  }

  Future<bool> userExists(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists;
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromDocument(doc);
    }
    return null;
  }

  Future<void> updateUserProfile(String uid, String bio, String displayName) async {
    await _db.collection('users').doc(uid).update({
      'bio': bio,
      'displayName': displayName,
    });
  }

  Stream<List<VideoModel>> getVideos({String? authorUid}) {
    Query query = _db.collection('videos').orderBy('createdAt', descending: true);
    if (authorUid != null) {
      query = query.where('authorUid', isEqualTo: authorUid);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => VideoModel.fromDocument(doc)).toList());
  }
}