import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../mid/mid_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _currentIndex = 0;

  // Only 2 Pages as requested
  final List<Widget> _pages = [
    const DashboardPage(),
    const MidPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // 1. The Content
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          // 2. The Floating Navigation Dock
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _buildFloatingNavBar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      // Compact width for 2 items
      width: 160, 
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F), // Dark grey/black
        borderRadius: BorderRadius.circular(34), // Fully rounded capsule
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, Icons.home_filled),        // Dashboard Icon
          _navItem(1, Icons.grid_view_rounded),  // Mid Page Icon (Task/Status)
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon) {
    final bool isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3E3E3E) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 26,
        ),
      ),
    );
  }
}