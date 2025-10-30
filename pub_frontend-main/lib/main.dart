// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/services/reservation_service.dart';
import 'package:jujeom_app/screens/welcome_page.dart';
import 'package:jujeom_app/screens/guide_page.dart';
import 'package:jujeom_app/screens/menu_page.dart';
import 'package:jujeom_app/screens/cart_page.dart';
import 'package:jujeom_app/screens/reservation_page.dart';
import 'package:jujeom_app/screens/confirmation_page.dart';
import 'package:jujeom_app/screens/additional_menu_page.dart';
import 'package:jujeom_app/screens/additional_cart_page.dart';
import 'package:jujeom_app/screens/additional_confirmation_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ReservationService(),
      child: const JujeomApp(),
    ),
  );
}

class JujeomApp extends StatelessWidget {
  const JujeomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '주점 예약 & 주문',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      // 기본 진입 페이지
      initialRoute: WelcomePage.routeName,
      // 모든 페이지를 routes에 등록해 직접 접근 허용
      routes: {
        WelcomePage.routeName: (_) => const WelcomePage(),
        GuidePage.routeName: (_) => const GuidePage(),
        ReservationPage.routeName: (_) => const ReservationPage(),
        MenuPage.routeName: (_) => const MenuPage(),
        CartPage.routeName: (_) => const CartPage(),
        ConfirmationPage.routeName: (_) => const ConfirmationPage(),
        AdditionalMenuPage.routeName: (_) => const AdditionalMenuPage(),
        AdditionalCartPage.routeName: (_) => const AdditionalCartPage(),
        AdditionalConfirmationPage.routeName: (_) => const AdditionalConfirmationPage(),
        // AdminPage.routeName: (_) => const AdminPage(),
      },
      // 미등록 경로는 WelcomePage로 리다이렉트
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const WelcomePage(),
      ),
    );
  }
}
