import 'dart:math';

import '../domain/sample_point.dart';

class SensorApiFake {
  Future<Map<String, List<Map<String, dynamic>>>> fetchDashboardJson() async {
    // Simulate small network/IO delay
    await Future.delayed(const Duration(milliseconds: 250));

    final day = _aggregate(_genSeries(1), 'day');
    final week = _aggregate(_genSeries(7), 'week');
    final month = _aggregate(_genSeries(30), 'month');
    final year = _aggregate(_genSeries(365, stepMin: 60), 'year');

    return {
      'day': day.map((e) => e.toJson()).toList(),
      'week': week.map((e) => e.toJson()).toList(),
      'month': month.map((e) => e.toJson()).toList(),
      'year': year.map((e) => e.toJson()).toList(),
    };
  }

  // ====== In-memory fake generator (from your original main.dart) ======

  List<SamplePoint> _genSeries(int days, {int stepMin = 15}) {
    final now = DateTime.now();
    final total = (days * 24 * 60) ~/ stepMin;
    final rnd = Random(2);
    final list = <SamplePoint>[];

    for (int i = total; i >= 0; i--) {
      final t = now.subtract(Duration(minutes: i * stepMin));

      final ph = 6.2 + sin(i / 7) * 0.2 + (rnd.nextDouble() - 0.5) * 0.05;
      final temp = 23 + sin(i / 5) * 1.2 + (rnd.nextDouble() - 0.5) * 0.5;
      final humid = 70 + cos(i / 6) * 5 + (rnd.nextDouble() - 0.5) * 2;
      final soil = 65 + cos(i / 4) * 6 + (rnd.nextDouble() - 0.5) * 3;
      final height =
          18 + (total - i) / total * 7 + (rnd.nextDouble() - 0.5) * 0.2;

      list.add(SamplePoint(t, ph, temp, humid, soil, height));
    }
    return list;
  }

  List<SamplePoint> _aggregate(List<SamplePoint> src, String bucket) {
    final map = <String, List<SamplePoint>>{};

    String keyOf(DateTime d) {
      return switch (bucket) {
        'day' => '${d.year}-${d.month}-${d.day} ${d.hour}',
        'week' => '${d.year}-${d.month}-${d.day}',
        'month' => '${d.year}-${d.month}-${d.day}',
        'year' => '${d.year}-${d.month}',
        _ => d.toIso8601String(),
      };
    }

    for (final p in src) {
      final k = keyOf(p.t);
      map.putIfAbsent(k, () => []).add(p);
    }

    return map.entries
        .map((e) {
      final xs = e.value;

      double avg(double Function(SamplePoint s) f) =>
          xs.map(f).reduce((a, b) => a + b) / xs.length;

      return SamplePoint(
        xs.first.t,
        avg((s) => s.ph),
        avg((s) => s.temp),
        avg((s) => s.humid),
        avg((s) => s.soil),
        avg((s) => s.height),
      );
    })
        .toList()
      ..sort((a, b) => a.t.compareTo(b.t));
  }
}
