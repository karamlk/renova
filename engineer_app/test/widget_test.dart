import 'package:flutter_test/flutter_test.dart';
import 'package:engineer_app/main.dart';

void main() {
  testWidgets('displays the engineer login screen', (tester) async {
    await tester.pumpWidget(const EngineerApp());
    expect(find.text('منصة المهندس'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
