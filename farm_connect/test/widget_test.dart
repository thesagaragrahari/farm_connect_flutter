import 'package:farm_connect/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app renders user module preview', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('FarmConnect'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Auth'), findsWidgets);
  });
}
