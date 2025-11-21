import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monitor_sawi/features/hydroponic/data/sensor_repository.dart';
import 'package:monitor_sawi/features/hydroponic/data/location_service.dart';
import 'package:monitor_sawi/features/hydroponic/data/weather_service.dart';
import 'package:monitor_sawi/features/hydroponic/domain/sample_point.dart';
import 'package:monitor_sawi/features/hydroponic/presentation/dashboard/dashboard_view_model.dart';
import 'package:monitor_sawi/features/hydroponic/data/sensor_api_fake.dart';

// Manual Mock
class MockSensorRepository implements SensorRepository {
  bool shouldThrow = false;
  
  @override
  Future<Map<String, List<SamplePoint>>> fetchDashboardSeries() async {
    // Add delay to simulate network and allow testing isLoading state
    await Future.delayed(const Duration(milliseconds: 10));
    
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return {
      'day': [
        SamplePoint(DateTime.now(), 6.0, 25.0, 70.0, 60.0, 20.0),
      ],
    };
  }
}

class MockLocationService implements LocationService {
  @override
  Future<Position> getCurrentPosition() async {
    return Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  @override
  Future<String> getPlacemarkFromCoordinates(double lat, double long) async {
    return 'Test City, Test Country';
  }
}

class MockWeatherService implements WeatherService {
  @override
  Future<Map<String, dynamic>> getCurrentWeather(double lat, double long) async {
    return {
      'temperature': 24.0,
      'weathercode': 0,
    };
  }

  @override
  String getWeatherCondition(int weatherCode) {
    return 'Sunny';
  }
}

void main() {
  group('DashboardViewModel', () {
    late DashboardViewModel viewModel;
    late MockSensorRepository mockRepository;
    late MockLocationService mockLocationService;
    late MockWeatherService mockWeatherService;

    setUp(() {
      mockRepository = MockSensorRepository();
      mockLocationService = MockLocationService();
      mockWeatherService = MockWeatherService();
      viewModel = DashboardViewModel(mockRepository, mockLocationService, mockWeatherService);
    });

    test('initial state is loading', () {
      // Since _load is called in constructor, it might finish fast or be async.
      // But initially it sets isLoading = true.
      // However, _load is async, so it won't finish immediately in the test execution unless we wait.
      expect(viewModel.isLoading, true);
      expect(viewModel.seriesByRange, isEmpty);
    });

    test('loads data successfully', () async {
      // Wait for the _load future to complete. 
      // Since we can't await the constructor, we might need to wait a bit or use pump if it was a widget test.
      // But for unit test, we can just wait for microtasks?
      // Actually, _load is fire-and-forget in constructor.
      // We can't easily await it.
      // But we can check that eventually it updates.
      
      // A better way to test this if we can't await the load is to verify the state change.
      // We can use `Future.delayed` to allow the async constructor work to finish.
      await Future.delayed(const Duration(milliseconds: 20));
      
      expect(viewModel.isLoading, false);
      expect(viewModel.seriesByRange, isNotEmpty);
      expect(viewModel.daySeries, isNotEmpty);
      expect(viewModel.error, isNull);
      
      // Test getters
      expect(viewModel.tempText, isNotNull);
    });

    test('handles error', () async {
      mockRepository.shouldThrow = true;
      // Re-create view model to trigger load with error
      viewModel = DashboardViewModel(mockRepository, mockLocationService, mockWeatherService);
      
      await Future.delayed(const Duration(milliseconds: 20));
      
      expect(viewModel.isLoading, false);
      expect(viewModel.error, 'Failed to load data');
      expect(viewModel.seriesByRange, isEmpty);
    });
  });
}
