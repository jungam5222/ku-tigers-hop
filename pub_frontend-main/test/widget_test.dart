// test/widget_test.dart

import 'dart:html' as html;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/main.dart';
import 'package:jujeom_app/services/reservation_service.dart';
import 'package:jujeom_app/screens/welcome_page.dart';
import 'package:jujeom_app/screens/confirmation_page.dart';

void main() {
  setUp(() {
    // 매 테스트마다 로컬스토리지 초기화
    html.window.localStorage.clear();
  });

  testWidgets('WelcomePage is shown when hasReserved is false', (WidgetTester tester) async {
    // 예약 안 했다고 표시
    html.window.localStorage['hasReserved'] = 'false';

    // Provider로 ReservationService 주입
    await tester.pumpWidget(
      ChangeNotifierProvider<ReservationService>(
        create: (_) => ReservationService(),
        child: const JujeomApp(),
      ),
    );
    await tester.pumpAndSettle();

    // WelcomePage와 '예약하기' 버튼이 보여야 함
    expect(find.byType(WelcomePage), findsOneWidget);
    expect(find.text('예약하기'), findsOneWidget);
  });

  testWidgets('ConfirmationPage is shown when hasReserved is true', (WidgetTester tester) async {
    // 이미 예약했다고 표시
    html.window.localStorage['hasReserved'] = 'true';

    await tester.pumpWidget(
      ChangeNotifierProvider<ReservationService>(
        create: (_) => ReservationService(),
        child: const JujeomApp(),
      ),
    );
    await tester.pumpAndSettle();

    // ConfirmationPage와 완료 메시지가 보여야 함
    expect(find.byType(ConfirmationPage), findsOneWidget);
    expect(find.text('예약 및 주문 완료'), findsOneWidget);
    expect(find.text('문자(SMS)를 확인해주세요'), findsOneWidget);
  });
}
