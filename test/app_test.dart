import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitor_sawi/app.dart';
import 'package:monitor_sawi/features/hydroponic/presentation/shell/shell_page.dart';
import 'package:monitor_sawi/features/hydroponic/presentation/dashboard/dashboard_page.dart';

void main() {
  testWidgets('App starts and shows ShellPage and DashboardPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HydroApp());

    // Initial state should show loading indicator (CircularProgressIndicator)
    // We verify ShellPage is there (it wraps the body)
    expect(find.byType(ShellPage), findsOneWidget);

    // Wait for the fake API delay (250ms) + a bit of buffer
    await tester.pump(const Duration(milliseconds: 300));
    
    // Pump again to process the state change (isLoading -> false)
    await tester.pump();

    // Verify that DashboardPage is present
    expect(find.byType(DashboardPage), findsOneWidget);
    
    // Verify loading is done (no CircularProgressIndicator)
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
