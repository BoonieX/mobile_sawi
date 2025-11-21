import 'package:flutter/material.dart';

class AnalyticPage extends StatelessWidget {
  const AnalyticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytic'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Analytic'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('CCTV'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('More info'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const Text(
                        'Greenhouse camera',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  ...List.generate(8, (i) {
                    final pos = Offset(
                      24 + (i % 4) * 80,
                      24 + (i ~/ 4) * 120,
                    );
                    return Positioned(
                      left: pos.dx,
                      top: pos.dy,
                      child: FilledButton.tonal(
                        onPressed: () {},
                        child: Text('Section ${i + 1}'),
                      ),
                    );
                  }),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: _dpad(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dpad() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_up),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}
