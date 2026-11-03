import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_mood.dart';

class WeatherService {
  static const double defaultLat = 24.8333;
  static const double defaultLon = 92.7789;

  Future<WeatherData> getCurrentWeather() async {
    double lat = defaultLat;
    double lon = defaultLon;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 5),
            ),
          );
          lat = pos.latitude;
          lon = pos.longitude;
        }
      }
    } catch (_) {
      // Fallback to default Silchar coordinates on any error
    }

    String cityName = "Local Area";
    try {
      final geoUri = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
      final geoResp = await http.get(geoUri, headers: {
        'User-Agent': 'SoulStreamApp/1.0',
      }).timeout(const Duration(seconds: 5));

      if (geoResp.statusCode == 200) {
        final data = jsonDecode(geoResp.body);
        final address = data['address'];
        if (address != null) {
          cityName = address['city'] ??
              address['town'] ??
              address['village'] ??
              address['county'] ??
              address['state'] ??
              "Local Area";
        }
      }
    } catch (_) {
      // Fallback to "Local Area"
    }

    try {
      final weatherUri = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true');
      final weatherResp = await http.get(weatherUri).timeout(const Duration(seconds: 5));

      if (weatherResp.statusCode == 200) {
        final data = jsonDecode(weatherResp.body);
        final currentWeather = data['current_weather'];
        if (currentWeather != null) {
          final double temp = (currentWeather['temperature'] as num).toDouble();
          final int code = (currentWeather['weathercode'] as num).toInt();

          return WeatherData.fromWmoCode(
            temperature: temp,
            code: code,
            cityName: cityName,
          );
        }
      }
    } catch (_) {
      // Fallback to default weather if Open-Meteo fails
    }

    return WeatherData.fromWmoCode(
      temperature: 25.0,
      code: 1,
      cityName: cityName,
    );
  }
}
