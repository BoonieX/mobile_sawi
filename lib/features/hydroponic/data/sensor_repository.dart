import '../domain/sample_point.dart';
import 'sensor_api_fake.dart';

class SensorRepository {
  final SensorApiFake _api;

  SensorRepository(this._api);

  Future<Map<String, List<SamplePoint>>> fetchDashboardSeries() async {
    final json = await _api.fetchDashboardJson();
    return json.map(
          (key, value) => MapEntry(
        key,
        value.map(SamplePoint.fromJson).toList(),
      ),
    );
  }
}
