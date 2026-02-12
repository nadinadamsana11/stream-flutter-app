import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/video_model.dart';
import '../widgets/video_card.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BEYOND REALITY AI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder<List<VideoModel>>(
        stream: DatabaseService().getVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No creations yet.'));
          }

          final videos = snapshot.data!;
          
          // Responsive Grid Layout
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 16 / 14,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: videos.length,
                itemBuilder: (context, index) => VideoCard(video: videos[index]),
              );
            },
          );
        },
      ),
    );
  }
}