import 'package:agrosafe/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('boots the application shell', (tester) async {
    await tester.pumpWidget(const AgrosafeApp());

    expect(find.byType(AgrosafeApp), findsOneWidget);
  });
}
