import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class PlayerManager extends ChangeNotifier {
  static final PlayerManager _instance = PlayerManager._internal();
  factory PlayerManager() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;

  Song? _currentSong;
  Song? get currentSong => _currentSong;

  List<Song> _queue = [];
  List<Song> get queue => _queue;
  int _currentIndex = -1;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Duration _position = Duration.zero;
  Duration get position => _position;

  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  List<Song> _favorites = [];
  List<Song> get favorites => _favorites;

  static const String _favKey = 'favorite_songs';

  PlayerManager._internal() {
    _initAudioPlayer();
    _loadFavorites();
  }

  void _initAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_favKey);
      if (jsonStr != null) {
        final List list = jsonDecode(jsonStr);
        _favorites = list.map((item) => Song.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _favorites.map((song) => song.toJson()).toList();
      await prefs.setString(_favKey, jsonEncode(list));
    } catch (_) {}
  }

  bool isFavorite(Song song) {
    return _favorites.any((item) => item.id == song.id || (item.title == song.title && item.artist == song.artist));
  }

  void toggleFavorite(Song song) {
    if (isFavorite(song)) {
      _favorites.removeWhere((item) => item.id == song.id || (item.title == song.title && item.artist == song.artist));
    } else {
      _favorites.add(song);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> playSong(Song song, {List<Song>? queue}) async {
    if (queue != null && queue.isNotEmpty) {
      _queue = queue;
      _currentIndex = _queue.indexWhere((s) => s.id == song.id || (s.title == song.title && s.artist == song.artist));
      if (_currentIndex == -1) {
        _queue.add(song);
        _currentIndex = _queue.length - 1;
      }
    } else {
      _queue = [song];
      _currentIndex = 0;
    }

    _currentSong = song;
    notifyListeners();

    try {
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> playNext() async {
    if (_queue.isNotEmpty && _currentIndex + 1 < _queue.length) {
      _currentIndex++;
      await playSong(_queue[_currentIndex], queue: _queue);
    }
  }

  Future<void> playPrevious() async {
    if (_queue.isNotEmpty && _currentIndex - 1 >= 0) {
      _currentIndex--;
      await playSong(_queue[_currentIndex], queue: _queue);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
