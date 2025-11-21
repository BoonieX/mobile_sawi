import 'package:flutter_test/flutter_test.dart';
import 'package:monitor_sawi/features/hydroponic/data/sensor_api_fake.dart';
import 'package:monitor_sawi/features/hydroponic/data/sensor_repository.dart';

void main() {
  group('SensorRepository', () {
    late SensorRepository repository;
    late SensorApiFake api;

    setUp(() {
      api = SensorApiFake();
      repository = SensorRepository(api);
    });

    test('fetchDashboardSeries returns data from api', () async {
      final result = await repository.fetchDashboardSeries();

      expect(result, isNotNull);
      expect(result.containsKey('day'), isTrue);
      expect(result.containsKey('week'), isTrue);
      expect(result.containsKey('month'), isTrue);
      expect(result.containsKey('year'), isTrue);

      expect(result['day'], isNotEmpty);
      expect(result['day']!.first.ph, isNotNull);
    });
  });
}
