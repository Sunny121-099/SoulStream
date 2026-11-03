import 'package:flutter/material.dart';
import '../models/song.dart';
import '../models/weather_mood.dart';
import '../services/music_service.dart';
import '../services/weather_service.dart';
import '../services/player_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final MusicService _musicService = MusicService();
  final TextEditingController _searchController = TextEditingController();

  WeatherData? _weatherData;
  bool _isLoadingWeather = true;
  bool _isLoadingMusic = false;
  List<Song> _songs = [];
  String _activeMood = "Weather Pick";

  final List<Map<String, String>> _moodFilters = [
    {"label": "Weather Pick", "query": ""},
    {"label": "Sunny & Upbeat", "query": "upbeat feel good hits"},
    {"label": "Rainy Day Acoustic", "query": "rainy day romantic acoustic"},
    {"label": "Chill Vibes", "query": "indie chill acoustic"},
    {"label": "Ambient & Lo-Fi", "query": "lofi chill beats"},
    {"label": "Electric Energy", "query": "synthwave electronic"},
    {"label": "Cozy Warmth", "query": "cozy winter piano"},
  ];

  @override
  void initState() {
    super.initState();
    _loadWeatherAndMusic();
  }

  Future<void> _loadWeatherAndMusic() async {
    setState(() {
      _isLoadingWeather = true;
    });

    final weather = await _weatherService.getCurrentWeather();
    setState(() {
      _weatherData = weather;
      _isLoadingWeather = false;
    });

    if (_activeMood == "Weather Pick") {
      _fetchSongs(weather.searchQuery);
    }
  }

  Future<void> _fetchSongs(String query) async {
    setState(() {
      _isLoadingMusic = true;
    });

    final results = await _musicService.searchSongs(query);

    setState(() {
      _songs = results;
      _isLoadingMusic = false;
    });
  }

  void _onMoodSelected(String label, String query) {
    setState(() {
      _activeMood = label;
    });

    if (label == "Weather Pick") {
      if (_weatherData != null) {
        _fetchSongs(_weatherData!.searchQuery);
      }
    } else {
      _fetchSongs(query);
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        _activeMood = "Search";
      });
      _fetchSongs(query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadWeatherAndMusic,
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Search songs or artists...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _onMoodSelected("Weather Pick", "");
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              // Weather Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: _isLoadingWeather
                    ? Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              (_weatherData?.accentColor ?? Colors.deepPurple).withOpacity(0.3),
                              Colors.grey[900]!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (_weatherData?.accentColor ?? Colors.deepPurple).withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      _weatherData?.cityName ?? 'Unknown Location',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_weatherData?.temperature.toStringAsFixed(1)}°C • ${_weatherData?.conditionName}',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _weatherData?.accentColor ?? Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Mood: ${_weatherData?.recommendedMood}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.white70),
                              onPressed: _loadWeatherAndMusic,
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 8),

              // Horizontal Mood Filter Chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _moodFilters.length,
                  itemBuilder: (context, index) {
                    final mood = _moodFilters[index];
                    final isSelected = _activeMood == mood['label'];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(mood['label']!),
                        selected: isSelected,
                        onSelected: (_) => _onMoodSelected(mood['label']!, mood['query']!),
                        selectedColor: Colors.deepPurpleAccent,
                        backgroundColor: Colors.grey[900],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[400],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Song List
              Expanded(
                child: _isLoadingMusic
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                      )
                    : _songs.isEmpty
                        ? const Center(
                            child: Text(
                              'No songs found. Try another search!',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListenableBuilder(
                            listenable: PlayerManager(),
                            builder: (context, _) {
                              final playerManager = PlayerManager();
                              final currentSong = playerManager.currentSong;

                              return ListView.builder(
                                itemCount: _songs.length,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                itemBuilder: (context, index) {
                                  final song = _songs[index];
                                  final isCurrent = currentSong?.id == song.id ||
                                      (currentSong?.title == song.title &&
                                          currentSong?.artist == song.artist);
                                  final isFav = playerManager.isFavorite(song);

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
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Container(
                                                  width: 48,
                                                  height: 48,
                                                  color: Colors.grey[800],
                                                  child: const Icon(Icons.music_note,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Container(
                                                width: 48,
                                                height: 48,
                                                color: Colors.grey[800],
                                                child: const Icon(Icons.music_note,
                                                    color: Colors.white),
                                              ),
                                      ),
                                      title: Text(
                                        song.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isCurrent
                                              ? Colors.deepPurpleAccent
                                              : Colors.white,
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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              isFav ? Icons.favorite : Icons.favorite_border,
                                              color: isFav ? Colors.redAccent : Colors.grey[500],
                                            ),
                                            onPressed: () {
                                              playerManager.toggleFavorite(song);
                                            },
                                          ),
                                          if (isCurrent && playerManager.isPlaying)
                                            const Icon(Icons.volume_up,
                                                color: Colors.deepPurpleAccent)
                                        ],
                                      ),
                                      onTap: () {
                                        playerManager.playSong(song, queue: _songs);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
