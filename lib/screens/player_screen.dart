import 'package:flutter/material.dart';
import '../services/player_manager.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerManager();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: playerManager,
        builder: (context, _) {
          final song = playerManager.currentSong;
          if (song == null) {
            return const Center(
              child: Text(
                'No song playing',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final isPlaying = playerManager.isPlaying;
          final isFav = playerManager.isFavorite(song);
          final position = playerManager.position;
          final duration = playerManager.duration;

          final double maxSliderValue = duration.inMilliseconds > 0
              ? duration.inMilliseconds.toDouble()
              : 1.0;
          final double currentSliderValue = position.inMilliseconds
              .toDouble()
              .clamp(0.0, maxSliderValue);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Album Art
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: song.imageUrl.isNotEmpty
                            ? Image.network(
                                song.imageUrl,
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 300,
                                  height: 300,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.music_note,
                                      size: 100, color: Colors.white),
                                ),
                              )
                            : Container(
                                width: 300,
                                height: 300,
                                color: Colors.grey[800],
                                child: const Icon(Icons.music_note,
                                    size: 100, color: Colors.white),
                              ),
                      ),
                    ),
                  ),

                  // Song Title & Artist & Favorite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                            if (song.album.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                song.album,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          playerManager.toggleFavorite(song);
                        },
                      ),
                    ],
                  ),

                  // Seek Slider
                  Column(
                    children: [
                      Slider(
                        value: currentSliderValue,
                        min: 0.0,
                        max: maxSliderValue,
                        activeColor: Colors.deepPurpleAccent,
                        inactiveColor: Colors.grey[800],
                        onChanged: (value) {
                          playerManager.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Playback Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                        onPressed: () {
                          playerManager.playPrevious();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.deepPurpleAccent,
                          size: 72,
                        ),
                        onPressed: () {
                          playerManager.togglePlayPause();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                        onPressed: () {
                          playerManager.playNext();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
