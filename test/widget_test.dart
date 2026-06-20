import 'package:satecho_mobile/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('boots the application shell', (tester) async {
    await tester.pumpWidget(const SatechoApp());

    expect(find.byType(SatechoApp), findsOneWidget);
  });
}
