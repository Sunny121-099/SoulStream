import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class MusicService {
  Future<List<Song>> searchSongs(String query) async {
    final encodedQuery = Uri.encodeComponent(query);

    // Try Saavn primary API
    try {
      final saavnUri = Uri.parse('https://saavn.dev/api/search/songs?query=$encodedQuery&limit=20');
      final resp = await http.get(saavnUri).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == true && data['data'] != null && data['data']['results'] != null) {
          final List results = data['data']['results'];
          if (results.isNotEmpty) {
            List<Song> songs = [];
            for (var item in results) {
              String id = item['id'] ?? '';
              String title = item['name'] ?? 'Unknown Title';
              String artist = 'Unknown Artist';
              if (item['artists'] != null && item['artists']['primary'] != null) {
                final primary = item['artists']['primary'] as List;
                if (primary.isNotEmpty) {
                  artist = primary.map((a) => a['name']).join(', ');
                }
              }
              String album = item['album']?['name'] ?? '';

              String imageUrl = '';
              if (item['image'] != null && (item['image'] as List).isNotEmpty) {
                imageUrl = (item['image'] as List).last['url'] ?? '';
              }

              String audioUrl = '';
              if (item['downloadUrl'] != null && (item['downloadUrl'] as List).isNotEmpty) {
                audioUrl = (item['downloadUrl'] as List).last['url'] ?? '';
              }

              int durationSec = item['duration'] != null ? int.tryParse(item['duration'].toString()) ?? 0 : 0;

              if (audioUrl.isNotEmpty) {
                songs.add(Song(
                  id: id,
                  title: title,
                  artist: artist,
                  album: album,
                  imageUrl: imageUrl,
                  audioUrl: audioUrl,
                  duration: Duration(seconds: durationSec),
                ));
              }
            }

            if (songs.isNotEmpty) {
              return songs;
            }
          }
        }
      }
    } catch (_) {
      // Ignore error and fall through to iTunes fallback
    }

    // Fallback to iTunes API
    try {
      final itunesUri = Uri.parse('https://itunes.apple.com/search?term=$encodedQuery&media=music&entity=song&limit=25');
      final resp = await http.get(itunesUri).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['results'] != null) {
          final List results = data['results'];
          List<Song> songs = [];
          for (var item in results) {
            String id = item['trackId']?.toString() ?? '';
            String title = item['trackName'] ?? 'Unknown Title';
            String artist = item['artistName'] ?? 'Unknown Artist';
            String album = item['collectionName'] ?? '';

            String imageUrl = item['artworkUrl100'] ?? '';
            if (imageUrl.isNotEmpty) {
              imageUrl = imageUrl.replaceAll('100x100bb', '600x600bb');
            }

            String audioUrl = item['previewUrl'] ?? '';
            int durationMs = item['trackTimeMillis'] ?? 0;

            if (audioUrl.isNotEmpty) {
              songs.add(Song(
                id: id,
                title: title,
                artist: artist,
                album: album,
                imageUrl: imageUrl,
                audioUrl: audioUrl,
                duration: Duration(milliseconds: durationMs),
              ));
            }
          }
          return songs;
        }
      }
    } catch (_) {
      // Fallback failed
    }

    return [];
  }
}
