import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../domain/metric_type.dart';
import '../../domain/sample_point.dart';
import '../../data/sensor_repository.dart';
import '../../data/location_service.dart';
import '../../data/weather_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final SensorRepository _repository;
  final LocationService _locationService;
  final WeatherService _weatherService;

  DashboardViewModel(
      this._repository, this._locationService, this._weatherService) {
    _load();
  }

  bool _isLoading = true;
  String? _error;
  Map<String, List<SamplePoint>> _seriesByRange = {};

  String _locationName = 'Loading...';
  String _currentDate = '';
  String _weatherCondition = '...';
  String _temperature = '--';

  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<String, List<SamplePoint>> get seriesByRange => _seriesByRange;

  String get locationName => _locationName;
  String get currentDate => _currentDate;
  String get weatherCondition => _weatherCondition;
  String get temperature => _temperature;

  List<SamplePoint> get daySeries =>
      _seriesByRange['day'] ?? const <SamplePoint>[];

  SamplePoint? get _latest => daySeries.isEmpty ? null : daySeries.last;

  // Simple API for a beginner UI teammate
  String get tempText =>
      _formatMetric(MetricType.temperature, _latest?.temp);

  String get phText => _formatMetric(MetricType.ph, _latest?.ph);

  String get humidityText =>
      _formatMetric(MetricType.humidity, _latest?.humid);

  String get soilText =>
      _formatMetric(MetricType.soil, _latest?.soil);

  String get heightText {
    final value = _latest?.height;
    if (value == null) return '-';
    return '${value.toStringAsFixed(1)} cm';
  }

  Future<void> _load() async {
    try {
      _isLoading = true;
      notifyListeners();

      _updateDate();
      // Fire and forget location/weather to not block the main dashboard loading
      _loadLocationAndWeather();

      _seriesByRange = await _repository.fetchDashboardSeries();

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load data';
      notifyListeners();
    }
  }

  void _updateDate() {
    final now = DateTime.now();
    _currentDate = DateFormat('EEE, d MMMM yyyy   hh:mm a').format(now);
  }

  Future<void> _loadLocationAndWeather() async {
    try {
      final position = await _locationService.getCurrentPosition();
      _locationName = await _locationService.getPlacemarkFromCoordinates(
          position.latitude, position.longitude);
      notifyListeners();

      final weather = await _weatherService.getCurrentWeather(
          position.latitude, position.longitude);
      _temperature = '${weather['temperature']}°C';
      _weatherCondition =
          _weatherService.getWeatherCondition(weather['weathercode']);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading location/weather: $e');
      if (_locationName == 'Loading...') {
        _locationName = 'Location Unavailable';
      }
      notifyListeners();
    }
  }

  String _formatMetric(MetricType metric, double? value) {
    if (value == null) return '-';
    return metric.format(value);
  }
}
