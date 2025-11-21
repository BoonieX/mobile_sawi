import 'metric_type.dart';

class Thresholds {
  final double min;
  final double max;

  const Thresholds({required this.min, required this.max});

  static Thresholds forMetric(MetricType metric) {
    switch (metric) {
      case MetricType.temperature:
        return const Thresholds(min: 18, max: 28);
      case MetricType.ph:
        return const Thresholds(min: 5.8, max: 6.5);
      case MetricType.humidity:
        return const Thresholds(min: 60, max: 80);
      case MetricType.soil:
        return const Thresholds(min: 50, max: 80);
    }
  }
}
