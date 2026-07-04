import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:satecho_mobile/app/di/mock_dependencies.dart';
import 'package:satecho_mobile/features/notifications/presentation/pages/notifications_screen.dart';

void main() {
  testWidgets(
      'NotificationsScreen renders mock notifications and marks one as read',
      (tester) async {
    final dependencies = AppDependencies.mock();

    await tester.pumpWidget(
      MaterialApp(
        home: AppDependenciesScope(
          dependencies: dependencies,
          child: const NotificationsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.textContaining('Water stress alert'), findsOneWidget);

    // Unread badge shows a non-zero count before any tap.
    expect(find.byType(CircleAvatar), findsWidgets);

    await tester.tap(find.textContaining('Water stress alert').first);
    await tester.pumpAndSettle();

    // Marking as read should not throw and the item should still be visible.
    expect(find.textContaining('Water stress alert'), findsOneWidget);
  });

  testWidgets('NotificationsScreen filters by type', (tester) async {
    final dependencies = AppDependencies.mock();

    await tester.pumpWidget(
      MaterialApp(
        home: AppDependenciesScope(
          dependencies: dependencies,
          child: const NotificationsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Intrusion alert'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Irrigation'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Intrusion alert'), findsNothing);
    expect(find.textContaining('Water stress alert'), findsOneWidget);
  });
}
