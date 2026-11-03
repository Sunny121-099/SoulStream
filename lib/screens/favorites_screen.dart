import 'package:flutter/material.dart';
import '../services/player_manager.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerManager();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Favorite Songs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: playerManager,
        builder: (context, _) {
          final favorites = playerManager.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  const Text(
                    'No favorite songs yet',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Heart tracks you love to save them here!',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            );
          }

          final currentSong = playerManager.currentSong;

          return ListView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final song = favorites[index];
              final isCurrent = currentSong?.id == song.id ||
                  (currentSong?.title == song.title &&
                      currentSong?.artist == song.artist);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Colors.deepPurple.withOpacity(0.2)
                      : Colors.grey[900]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: song.imageUrl.isNotEmpty
                        ? Image.network(
                            song.imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
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
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent ? Colors.deepPurpleAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    onPressed: () {
                      playerManager.toggleFavorite(song);
                    },
                  ),
                  onTap: () {
                    playerManager.playSong(song, queue: favorites);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
