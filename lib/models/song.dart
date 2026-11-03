class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final String audioUrl;
  final Duration duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'album': album,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'duration': duration.inMilliseconds,
      };

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json['id'],
        title: json['title'],
        artist: json['artist'],
        album: json['album'],
        imageUrl: json['imageUrl'],
        audioUrl: json['audioUrl'],
        duration: Duration(milliseconds: json['duration']),
      );
}
