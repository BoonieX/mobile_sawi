// lib/main.dart
// Hydroponic Monitor – pixel-faithful UI to the provided mock
// pubspec.yaml add:
//   google_fonts: ^6.2.1
//   fl_chart: ^0.66.2
// Run: flutter run

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const HydroApp());
}

class HydroApp extends StatelessWidget {
  const HydroApp({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF22C55E));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hydroponic Monitor',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF3F4F6), surfaceTintColor: Colors.transparent, elevation: 0, centerTitle: false),
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Colors.grey.shade200)),
          margin: EdgeInsets.zero,
        ),
        dividerTheme: DividerThemeData(color: Colors.grey.shade200),
      ),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget { const Shell({super.key}); @override State<Shell> createState() => _ShellState(); }
class _ShellState extends State<Shell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const DashboardScreen(), const MidScreen(), const AnalyticScreen()];
    return Scaffold(
      body: SafeArea(child: pages[index]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .15), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        width: 56, height: 56, alignment: Alignment.center,
        child: const Icon(Icons.center_focus_strong, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 66,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _navIcon(Icons.home_rounded, index == 0, onTap: ()=>setState(()=>index=0)),
          _navIcon(Icons.tune_rounded, index == 1, onTap: ()=>setState(()=>index=1)),
          const SizedBox(width: 56), // space for center pill
          _navIcon(Icons.sensors, index == 2, onTap: ()=>setState(()=>index=2)),
          _navIcon(Icons.list_alt, false),
        ]),
      ),
    );
  }

  Widget _navIcon(IconData icon, bool active, {VoidCallback? onTap}) {
    return InkResponse(
      onTap: onTap,
      child: Icon(icon, size: 26, color: active ? Colors.black : Colors.grey.shade500),
    );
  }
}

// ====== DASHBOARD (left mock) ======
class DashboardScreen extends StatefulWidget { const DashboardScreen({super.key}); @override State<DashboardScreen> createState() => _DashboardScreenState(); }
class _DashboardScreenState extends State<DashboardScreen> {
  late final Map<String, List<SamplePoint>> data;
  @override
  void initState() {
    super.initState();
    data = {
      'day': aggregate(genSeries(1), 'day'),
      'week': aggregate(genSeries(7), 'week'),
      'month': aggregate(genSeries(30), 'month'),
      'year': aggregate(genSeries(365, stepMin: 60), 'year'),
    };
  }
  List<SamplePoint> get current => data['day'] ?? <SamplePoint>[];

  @override
  Widget build(BuildContext context) {
    final latest = current.isEmpty ? null : current.last;
    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: true,
        titleSpacing: 16,
        title: Row(children: [
          Container(width: 36, height: 36, decoration: const BoxDecoration(color: Color(0xFFE8F7EE), shape: BoxShape.circle), child: const Icon(Icons.eco, color: Color(0xFF22C55E))),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Weilburg, Germany', style: Theme.of(context).textTheme.titleMedium),
            Text('Tue, 10 September 2024     09:37 AM', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]))
          ]),
          const Spacer(),
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none)),
          const CircleAvatar(radius: 16, backgroundColor: Colors.black12, child: Icon(Icons.person, size: 16, color: Colors.black54)),
        ]),
      ),
      SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverToBoxAdapter(
          child: Column(children: [
            // Weather + Temp
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
              const Icon(Icons.wb_sunny_outlined), const SizedBox(width: 8),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('Sunny'), Text('H26°C  L12°C', style: TextStyle(color: Colors.grey))])),
              Text('24°C', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800))
            ]))),
            const SizedBox(height: 10),

            // KPI grid matching mock
            Wrap(spacing: 10, runSpacing: 10, children: [
              _plantHealth(),
              _kpi('Wind', '2 m/s', Icons.air),
              _kpi('Temperature', _latestValue(latest, MetricType.temperature), Icons.thermostat,
                onTap: current.isEmpty ? null : ()=>_openMetricDetail(MetricType.temperature)),
              _kpi('pH Level', _latestValue(latest, MetricType.ph), Icons.science_outlined,
                onTap: current.isEmpty ? null : ()=>_openMetricDetail(MetricType.ph)),
              _kpi('Humidity', _latestValue(latest, MetricType.humidity), Icons.water_drop,
                onTap: current.isEmpty ? null : ()=>_openMetricDetail(MetricType.humidity)),
              _kpi('Soil Moisture', _latestValue(latest, MetricType.soil), Icons.opacity_outlined,
                onTap: current.isEmpty ? null : ()=>_openMetricDetail(MetricType.soil)),
            ]),

            const SizedBox(height: 12),
            // Device banner strip like mock
            Card(child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Device', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  const Text('JLNew H10: Soil Moisture Sensor', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('#WS004 – Camera 5', style: TextStyle(color: Colors.grey.shade600)),
                ])),
                const Icon(Icons.home_filled), const SizedBox(width: 16),
                const Icon(Icons.analytics_outlined), const SizedBox(width: 16),
                const Icon(Icons.grid_view_rounded), const SizedBox(width: 16),
                const Icon(Icons.settings_outlined),
              ]),
            )),
          ]),
        ),
      ),
    ]);
  }

  Widget _plantHealth() {
    return SizedBox(
      width: 220,
      child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children:[Container(decoration: BoxDecoration(color: const Color(0xFFE8F7EE), borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.all(8), child: const Icon(Icons.eco, color: Color(0xFF22C55E))), const SizedBox(width: 8), const Text('Plant Health')]),
        const SizedBox(height: 8),
        Row(children:[Text('94%', style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w800)), const SizedBox(width: 8), const Chip(label: Text('Good'))])
      ]))),
    );
  }

  Widget _kpi(String label, String value, IconData icon, {VoidCallback? onTap}) {
    return SizedBox(
      width: 150,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
              Row(children:[Icon(icon), const SizedBox(width: 8), Text(label)]),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18))
            ]),
          ),
        ),
      ),
    );
  }

  void _openMetricDetail(MetricType metric) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: .88,
        child: MetricDetailSheet(metric: metric, data: data),
      ),
    );
  }

  String _latestValue(SamplePoint? sample, MetricType metric) {
    if (sample == null) return '-';
    return metric.format(metric.accessor(sample));
  }
}

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
    MetricType.temperature => (p)=>p.temp,
    MetricType.ph => (p)=>p.ph,
    MetricType.humidity => (p)=>p.humid,
    MetricType.soil => (p)=>p.soil,
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

class MetricDetailSheet extends StatefulWidget {
  final MetricType metric;
  final Map<String, List<SamplePoint>> data;
  const MetricDetailSheet({super.key, required this.metric, required this.data});

  @override
  State<MetricDetailSheet> createState() => _MetricDetailSheetState();
}

class _MetricDetailSheetState extends State<MetricDetailSheet> {
  static const _ranges = ['day', 'week', 'month', 'year'];
  int selectedRange = 0;

  List<SamplePoint> get points => widget.data[_ranges[selectedRange]] ?? <SamplePoint>[];

  @override
  Widget build(BuildContext context) {
    final metric = widget.metric;
    final values = points.map(metric.accessor).toList();
    final latest = values.isNotEmpty ? values.last : null;
    final average = values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : null;
    final minValue = values.isNotEmpty ? values.reduce(min) : null;
    final maxValue = values.isNotEmpty ? values.reduce(max) : null;

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
                child: Icon(metric.icon),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(metric.label, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                Text('View ${_ranges[selectedRange]} trend', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
              ])),
              IconButton(onPressed: ()=>Navigator.of(context).maybePop(), icon: const Icon(Icons.close_rounded))
            ]),
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
              onSelectionChanged: (value) => setState(() => selectedRange = value.first),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: _statTile('Latest', latest == null ? '-' : metric.format(latest))),
              const SizedBox(width: 12),
              Expanded(child: _statTile('Average', average == null ? '-' : metric.format(average))),
            ]),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: _statTile('Low', minValue == null ? '-' : metric.format(minValue))),
              const SizedBox(width: 12),
              Expanded(child: _statTile('High', maxValue == null ? '-' : metric.format(maxValue))),
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: values.isEmpty
                  ? const Center(child: Text('No readings available'))
                  : _MetricChart(points: points, metric: metric, rangeLabel: _ranges[selectedRange]),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      ]),
    );
  }
}

class _MetricChart extends StatelessWidget {
  final List<SamplePoint> points;
  final MetricType metric;
  final String rangeLabel;
  const _MetricChart({required this.points, required this.metric, required this.rangeLabel});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[];
    for (int i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), metric.accessor(points[i])));
    }
    final values = spots.map((e) => e.y).toList();
    final minY = values.reduce(min) - metric.padding;
    final maxY = values.reduce(max) + metric.padding;
    final interval = spots.length <= 1 ? 1.0 : (spots.length / 4).ceilToDouble();
    final yRange = (maxY - minY).abs();
    final yInterval = yRange == 0 ? 1.0 : (yRange / 4).clamp(0.1, double.infinity).toDouble();

    return LineChart(LineChartData(
      minY: minY,
      maxY: maxY,
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            getTitlesWidget: (value, meta) => _bottomTitle(value, meta),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            interval: yInterval,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(switch (metric) {
                MetricType.temperature => 1,
                MetricType.ph => 1,
                _ => 0,
              }),
              style: const TextStyle(fontSize: 11),
            ),
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
                Theme.of(context).colorScheme.primary.withValues(alpha: .25),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    final idx = value.round();
    if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
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

// ====== MIDDLE SCREEN (alert + camera + tasks like mock) ======
class MidScreen extends StatelessWidget { const MidScreen({super.key});
@override
  Widget build(BuildContext context) {
  return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
    Card(child: ListTile(leading: const Icon(Icons.sensors), title: const Text('ACE Temperature & Humidity Sensor'), subtitle: Row(children:[const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 18), const SizedBox(width: 6), Text('Signal issue since 08:02 AM', style: TextStyle(color: Colors.amber.shade800))]))),
    const SizedBox(height: 12),
    Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Row(children:[const Text('Camera 1'), const Spacer(), IconButton(onPressed: (){}, icon: const Icon(Icons.open_in_full))]),
      ClipRRect(borderRadius: BorderRadius.circular(12), child: AspectRatio(aspectRatio: 16/9, child: Container(color: Colors.black, alignment: Alignment.center, child: const Text('Greenhouse stream', style: TextStyle(color: Colors.white70))))),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.end, children:[
        FilledButton.tonal(onPressed: (){}, child: const Icon(Icons.photo_camera_outlined)), const SizedBox(width: 8),
        FilledButton.tonal(onPressed: (){}, child: const Icon(Icons.videocam_outlined)), const SizedBox(width: 8),
        FilledButton.tonal(onPressed: (){}, child: const Icon(Icons.open_in_full)),
      ])
    ]))),
    const SizedBox(height: 12),
    Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Row(children:[Text('Task', style: Theme.of(context).textTheme.titleSmall), const Spacer(), const Text('2/5 Task Completed')]),
      const SizedBox(height: 6), const LinearProgressIndicator(value: .4), const SizedBox(height: 8),
      _task('Watering', 'Water plants with 1 inch of water in the morning', true),
      _task('Fertilizing', 'Apply organic fertilizer at base of plants', true),
      _task('Pest Inspection', 'Check leaves for any signs of aphids or other pests', false),
    ])))
  ]));
}

Widget _task(String t, String s, bool done) => CheckboxListTile(
  value: done, onChanged: (_) {}, dense: true, controlAffinity: ListTileControlAffinity.leading,
  title: Text(t), subtitle: Text(s),
);
}

// ====== RIGHT SCREEN (Analytic with overlay + dpad) ======
class AnalyticScreen extends StatelessWidget { const AnalyticScreen({super.key});
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Analytic'), actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz))]),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children:[
          FilledButton.tonal(onPressed: (){}, child: const Text('Analytic')),
          const SizedBox(width: 8), OutlinedButton(onPressed: (){}, child: const Text('CCTV')),
          const SizedBox(width: 8), OutlinedButton(onPressed: (){}, child: const Text('More info')),
        ]),
        const SizedBox(height: 10),
        Expanded(
          child: Stack(children:[
            ClipRRect(borderRadius: BorderRadius.circular(16), child: Container(color: Colors.black, alignment: Alignment.center, child: const Text('Greenhouse camera', style: TextStyle(color: Colors.white70)))),
            ...List.generate(8, (i){
              final pos = Offset(24 + (i%4)*80, 24 + (i~/4)*120);
              return Positioned(left: pos.dx, top: pos.dy, child: FilledButton.tonal(onPressed: (){}, child: Text('Section ${i+1}')));
            }),
            Positioned(right: 12, bottom: 12, child: _dpad())
          ]),
        ),
      ]),
    ),
  );
}

Widget _dpad() => Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 12)]),
  child: Column(children:[
    IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_up)),
    Row(children:[IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_left)), const SizedBox(width: 4), IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_right))]),
    IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_down)),
  ]),
);
}

// ===== Data + aggregation =====
class SamplePoint {
  final DateTime t;
  final double ph, temp, humid, soil, height;
  SamplePoint(this.t, this.ph, this.temp, this.humid, this.soil, this.height);
}
List<SamplePoint> genSeries(int days, {int stepMin = 15}) {
  final now = DateTime.now(); final total = (days*24*60)~/stepMin; final rnd = Random(2); final list=<SamplePoint>[];
  for (int i=total;i>=0;i--) { final t=now.subtract(Duration(minutes: i*stepMin));
  final ph=6.2+sin(i/7)*0.2+(rnd.nextDouble()-0.5)*0.05;
  final temp=23+sin(i/5)*1.2+(rnd.nextDouble()-0.5)*0.5;
  final humid=70+cos(i/6)*5+(rnd.nextDouble()-0.5)*2;
  final soil=65+cos(i/4)*6+(rnd.nextDouble()-0.5)*3;
  final height=18+max(0,(total-i)/total)*7+(rnd.nextDouble()-0.5)*0.2;
  list.add(SamplePoint(t, ph, temp, humid, soil, height)); }
  return list;
}
List<SamplePoint> aggregate(List<SamplePoint> src, String bucket) {
  final map=<String,List<SamplePoint>>{}; String keyOf(DateTime d){
    return switch(bucket){
      'day' => '${d.year}-${d.month}-${d.day} ${d.hour}',
      'week' => '${d.year}-${d.month}-${d.day}',
      'month' => '${d.year}-${d.month}-${d.day}',
      'year' => '${d.year}-${d.month}',
      _ => d.toIso8601String(),};}
  for(final p in src){final k=keyOf(p.t); map.putIfAbsent(k, ()=>[]).add(p);}
  return map.entries.map((e){
    final xs=e.value;
    double avg(double Function(SamplePoint s) f)=>xs.map(f).reduce((a,b)=>a+b)/xs.length;
    return SamplePoint(
      xs.first.t,
      avg((s)=>s.ph),
      avg((s)=>s.temp),
      avg((s)=>s.humid),
      avg((s)=>s.soil),
      avg((s)=>s.height),
    );
  }).toList()..sort((a,b)=>a.t.compareTo(b.t));
}
