import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'features/hydroponic/data/sensor_api_fake.dart';
import 'features/hydroponic/data/sensor_repository.dart';
import 'features/hydroponic/data/location_service.dart';
import 'features/hydroponic/data/weather_service.dart';
import 'features/hydroponic/presentation/dashboard/dashboard_view_model.dart';
import 'features/hydroponic/presentation/shell/shell_page.dart';

class HydroApp extends StatelessWidget {
  const HydroApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF22C55E));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            SensorRepository(SensorApiFake()),
            LocationService(),
            WeatherService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hydroponic Monitor',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: scheme,
          textTheme: GoogleFonts.interTextTheme(),
          scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        ),
        home: const ShellPage(),
      ),
    );
  }
}
