import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard/dashboard_page.dart';
import '../mid/mid_page.dart';
// We can use a placeholder for the 3rd page since we are focusing on the first two
import '../analytic/analytic_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(), // Screen 1
    const MidPage(),       // Screen 2
    const AnalyticPage(),  // Screen 3 (Placeholder)
    const Scaffold(body: Center(child: Text("Map"))), // Placeholder
    const Scaffold(body: Center(child: Text("Settings"))), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // 1. The Content
          // We use IndexedStack to keep state alive
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // 2. The Floating Bottom Navigation
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F), // Dark grey/black
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, Icons.home_filled),
          _navItem(1, Icons.article_outlined), // Document/List icon
          _navItem(2, Icons.pie_chart_outline), // Analytic icon
          _navItem(3, Icons.map_outlined),
          _navItem(4, Icons.settings_outlined),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3E3E3E) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}