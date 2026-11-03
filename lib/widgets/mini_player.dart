import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/player_manager.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerManager();

    return ListenableBuilder(
      listenable: playerManager,
      builder: (context, _) {
        final currentSong = playerManager.currentSong;
        if (currentSong == null) {
          return const SizedBox.shrink();
        }

        final isPlaying = playerManager.isPlaying;
        final isFav = playerManager.isFavorite(currentSong);
        final position = playerManager.position;
        final duration = playerManager.duration;

        double progress = 0.0;
        if (duration.inMilliseconds > 0) {
          progress = (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
        }

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PlayerScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: currentSong.imageUrl.isNotEmpty
                            ? Image.network(
                                currentSong.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.music_note, color: Colors.white),
                                ),
                              )
                            : Container(
                                width: 48,
                                height: 48,
                                color: Colors.grey[800],
                                child: const Icon(Icons.music_note, color: Colors.white),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentSong.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.grey[400],
                        ),
                        onPressed: () {
                          playerManager.toggleFavorite(currentSong);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.white,
                          size: 36,
                        ),
                        onPressed: () {
                          playerManager.togglePlayPause();
                        },
                      ),
                    ],
                  ),
                ),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                  minHeight: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
