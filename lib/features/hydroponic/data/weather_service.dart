import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double long) async {
    final url = Uri.parse('$_baseUrl?latitude=$lat&longitude=$long&current_weather=true');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['current_weather'];
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service: $e');
    }
  }
  
  String getWeatherCondition(int weatherCode) {
    // WMO Weather interpretation codes (WW)
    if (weatherCode == 0) return 'Sunny';
    if (weatherCode >= 1 && weatherCode <= 3) return 'Cloudy';
    if (weatherCode >= 45 && weatherCode <= 48) return 'Foggy';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Rainy';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Snowy';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Rainy';
    if (weatherCode >= 85 && weatherCode <= 86) return 'Snowy';
    if (weatherCode >= 95) return 'Stormy';
    return 'Unknown';
  }
}
