import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';
import '../../models/video_model.dart';
import '../../widgets/custom_toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseService _dbService = DatabaseService();
  bool _isEditing = false;
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) return const Scaffold(body: Center(child: Text('Please login')));

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: FutureBuilder<UserModel?>(
        future: _dbService.getUser(currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final userModel = snapshot.data!;
          if (!_isEditing) {
            _bioController.text = userModel.bio ?? '';
            _nameController.text = userModel.displayName ?? userModel.username;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userModel.photoUrl!),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userModel.displayName ?? userModel.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('@${userModel.username}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isEditing ? Icons.close : Icons.edit),
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                
                // Edit Form or Display Bio
                if (_isEditing) ...[
                  TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Display Name')),
                  const SizedBox(height: 10),
                  TextField(controller: _bioController, decoration: const InputDecoration(labelText: 'Bio'), maxLines: 3),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _dbService.updateUserProfile(currentUser!.uid, _bioController.text, _nameController.text);
                      await currentUser!.updateDisplayName(_nameController.text);
                      setState(() => _isEditing = false);
                      if (mounted) CustomToast.show(context, 'Profile Updated');
                    },
                    child: const Text('Save Changes'),
                  )
                ] else
                  Text(userModel.bio?.isNotEmpty == true ? userModel.bio! : 'No bio yet.', style: const TextStyle(color: Colors.white70)),

                const Divider(height: 40),
                const Text('Your Videos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // User Videos List
                StreamBuilder<List<VideoModel>>(
                  stream: _dbService.getVideos(authorUid: currentUser!.uid),
                  builder: (context, videoSnap) {
                    if (!videoSnap.hasData) return const SizedBox();
                    final videos = videoSnap.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: videos.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Image.network(videos[index].thumbnailUrl, width: 80, fit: BoxFit.cover),
                        title: Text(videos[index].title),
                        subtitle: Text(videos[index].duration),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}