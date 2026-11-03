import 'package:flutter/material.dart';

class WeatherData {
  final double temperature;
  final int weatherCode;
  final String conditionName;
  final String cityName;
  final String recommendedMood;
  final String searchQuery;
  final Color accentColor;

  WeatherData({
    required this.temperature,
    required this.weatherCode,
    required this.conditionName,
    required this.cityName,
    required this.recommendedMood,
    required this.searchQuery,
    required this.accentColor,
  });

  factory WeatherData.fromWmoCode({
    required double temperature,
    required int code,
    required String cityName,
  }) {
    String conditionName;
    String mood;
    String query;
    Color color;

    switch (code) {
      case 0:
      case 1:
        conditionName = 'Clear / Sunny';
        mood = 'Sunny & Upbeat';
        query = 'upbeat feel good hits';
        color = Colors.orangeAccent;
        break;
      case 2:
      case 3:
        conditionName = 'Partly Cloudy';
        mood = 'Chill Vibes';
        query = 'indie chill acoustic';
        color = Colors.lightBlueAccent;
        break;
      case 45:
      case 48:
        conditionName = 'Fog / Mist';
        mood = 'Ambient & Lo-Fi';
        query = 'lofi chill beats';
        color = Colors.blueGrey;
        break;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        conditionName = 'Rain / Drizzle';
        mood = 'Rainy Day Acoustic';
        query = 'rainy day romantic acoustic';
        color = Colors.indigoAccent;
        break;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        conditionName = 'Snow';
        mood = 'Cozy Warmth';
        query = 'cozy winter piano';
        color = Colors.cyanAccent;
        break;
      case 95:
      case 96:
      case 99:
        conditionName = 'Thunderstorm';
        mood = 'Electric Energy';
        query = 'synthwave electronic';
        color = Colors.deepPurpleAccent;
        break;
      default:
        conditionName = 'Unknown Weather';
        mood = 'Chill Vibes';
        query = 'indie chill acoustic';
        color = Colors.blueAccent;
        break;
    }

    return WeatherData(
      temperature: temperature,
      weatherCode: code,
      conditionName: conditionName,
      cityName: cityName,
      recommendedMood: mood,
      searchQuery: query,
      accentColor: color,
    );
  }
}
