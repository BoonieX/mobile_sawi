import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MidPage extends StatelessWidget {
  const MidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Header matching the design
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.eco, color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded, size: 28),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 40, height: 40,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 24),

              // 1. Sensor Card with Warning
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 10, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "ACE Temperature & Humidity Sensor",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 4),
                      child: Text(
                        "#TH011  •  Sensor",
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Warning Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1), // Light Orange/Yellow
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Signal issue since 08:02 AM",
                            style: GoogleFonts.inter(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Camera Card (UI Only)
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1585320806297-331a7d798a3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (c,e,s) => Container(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                    // Overlay Gradient
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Header
                    Positioned(
                      top: 16, left: 16, right: 16,
                      child: Row(
                        children: [
                          const Icon(Icons.signal_cellular_alt, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "Camera 1",
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.north_east, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    ),
                    // Bottom Controls
                    Positioned(
                      bottom: 16, left: 16, right: 16,
                      child: Row(
                        children: [
                          Text("1/5", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          _camBtn(Icons.arrow_back),
                          const SizedBox(width: 8),
                          _camBtn(Icons.camera_alt_outlined),
                          const SizedBox(width: 8),
                          _camBtn(Icons.notifications_none),
                          const SizedBox(width: 8),
                          _camBtn(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Task Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Task", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Icon(Icons.north_east, size: 18, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.4,
                        minHeight: 6,
                        backgroundColor: Colors.grey[200],
                        color: const Color(0xFF22C55E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("40%", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        Text("2/5 Task Completed", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tasks
                    _taskItem("Watering", "Water plants with 1 inch of water in the morning", "07:00 AM - 07:30 AM", true),
                    _taskItem("Fertilizing", "Apply organic fertilizer at base of plants", null, true),
                    _taskItem("Pest Inspection", "Check leaves for any signs of aphids", null, false),
                  ],
                ),
              ),

              const SizedBox(height: 120), // Padding for nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _camBtn(IconData icon) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _taskItem(String title, String sub, String? time, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Text(sub, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13)),
                if (time != null) ...[
                  const SizedBox(height: 4),
                  Text(time, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12)),
                ]
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? const Color(0xFF22C55E) : Colors.transparent,
              border: Border.all(color: done ? const Color(0xFF22C55E) : Colors.grey[300]!, width: 2),
            ),
            child: done ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
          )
        ],
      ),
    );
  }
}