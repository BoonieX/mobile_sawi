import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/metric_type.dart';
import '../../domain/sample_point.dart';

class MetricDetailSheet extends StatefulWidget {
  final MetricType metric;
  final Map<String, List<SamplePoint>> data;

  const MetricDetailSheet({
    super.key,
    required this.metric,
    required this.data,
  });

  @override
  State<MetricDetailSheet> createState() => _MetricDetailSheetState();
}

class _MetricDetailSheetState extends State<MetricDetailSheet> {
  static const _ranges = ['day', 'week', 'month', 'year'];
  int selectedRange = 0;

  List<SamplePoint> get points =>
      widget.data[_ranges[selectedRange]] ?? <SamplePoint>[];

  @override
  Widget build(BuildContext context) {
    final metric = widget.metric;
    final values = points.map(metric.accessor).toList();
    final latest = values.isNotEmpty ? values.last : null;
    final average =
    values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : null;
    final minValue = values.isNotEmpty ? values.reduce(min) : null;
    final maxValue = values.isNotEmpty ? values.reduce(max) : null;

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(metric.icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metric.label,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'View ${_ranges[selectedRange]} trend',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Day')),
                ButtonSegment(value: 1, label: Text('Week')),
                ButtonSegment(value: 2, label: Text('Month')),
                ButtonSegment(value: 3, label: Text('Year')),
              ],
              selected: {selectedRange},
              onSelectionChanged: (value) {
                setState(() => selectedRange = value.first);
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _statTile(
                    'Latest',
                    latest == null ? '-' : metric.format(latest),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statTile(
                    'Average',
                    average == null ? '-' : metric.format(average),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _statTile(
                    'Low',
                    minValue == null ? '-' : metric.format(minValue),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statTile(
                    'High',
                    maxValue == null ? '-' : metric.format(maxValue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: values.isEmpty
                  ? const Center(child: Text('No readings available'))
                  : _MetricChart(
                points: points,
                metric: metric,
                rangeLabel: _ranges[selectedRange],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _statTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChart extends StatelessWidget {
  final List<SamplePoint> points;
  final MetricType metric;
  final String rangeLabel;

  const _MetricChart({
    required this.points,
    required this.metric,
    required this.rangeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (int i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), metric.accessor(points[i])));
    }

    final values = spots.map((e) => e.y).toList();
    final minY = values.reduce(min) - metric.padding;
    final maxY = values.reduce(max) + metric.padding;
    final interval =
    spots.length <= 1 ? 1.0 : (spots.length / 4).ceilToDouble();
    final yRange = (maxY - minY).abs();
    final yInterval =
    yRange == 0 ? 1.0 : (yRange / 4).clamp(0.1, double.infinity).toDouble();

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              getTitlesWidget: (value, meta) =>
                  _bottomTitle(value, meta, points, rangeLabel),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                final decimals = switch (metric) {
                  MetricType.temperature => 1,
                  MetricType.ph => 1,
                  _ => 0,
                };
                return Text(
                  value.toStringAsFixed(decimals),
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: yInterval,
          verticalInterval: interval,
          drawVerticalLine: true,
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: spots,
            barWidth: 3,
            color: Theme.of(context).colorScheme.primary,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .25),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bottomTitle(
      double value,
      TitleMeta meta,
      List<SamplePoint> points,
      String rangeLabel,
      ) {
    final idx = value.round();
    if (idx < 0 || idx >= points.length) {
      return const SizedBox.shrink();
    }
    final t = points[idx].t;

    String label;
    switch (rangeLabel) {
      case 'day':
        final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
        final suffix = t.hour >= 12 ? 'PM' : 'AM';
        label = '$hour$suffix';
        break;
      case 'week':
      case 'month':
        label = '${t.month}/${t.day}';
        break;
      case 'year':
        label = '${t.month}/${t.year % 100}';
        break;
      default:
        label = '${t.hour}:00';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}
