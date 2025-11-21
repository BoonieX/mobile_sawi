import 'package:flutter/material.dart';

import 'sample_point.dart';

enum MetricType { temperature, ph, humidity, soil }

extension MetricDescriptor on MetricType {
  String get label => switch (this) {
    MetricType.temperature => 'Temperature',
    MetricType.ph => 'pH Level',
    MetricType.humidity => 'Humidity',
    MetricType.soil => 'Soil Moisture',
  };

  IconData get icon => switch (this) {
    MetricType.temperature => Icons.thermostat,
    MetricType.ph => Icons.science_outlined,
    MetricType.humidity => Icons.water_drop,
    MetricType.soil => Icons.opacity_outlined,
  };

  double Function(SamplePoint) get accessor => switch (this) {
    MetricType.temperature => (p) => p.temp,
    MetricType.ph => (p) => p.ph,
    MetricType.humidity => (p) => p.humid,
    MetricType.soil => (p) => p.soil,
  };

  String format(double value) {
    final digits = switch (this) {
      MetricType.temperature => 1,
      MetricType.ph => 2,
      MetricType.humidity => 0,
      MetricType.soil => 0,
    };
    final suffix = switch (this) {
      MetricType.temperature => '°C',
      MetricType.ph => '',
      MetricType.humidity => '%',
      MetricType.soil => '%',
    };
    final text = value.toStringAsFixed(digits);
    return suffix.isEmpty ? text : '$text$suffix';
  }

  double get padding => switch (this) {
    MetricType.temperature => 1,
    MetricType.ph => .1,
    MetricType.humidity => 4,
    MetricType.soil => 4,
  };
}
