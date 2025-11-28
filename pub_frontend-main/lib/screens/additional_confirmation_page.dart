// lib/screens/confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';
import 'package:jujeom_app/services/reservation_service.dart';

/// 대각선으로 상단 회색과 하단 흰색을 나누는 페인터
class DiagonalPainter extends CustomPainter {
  final Color color;
  DiagonalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h / 3)
      ..lineTo(0, 2 * h / 3)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AdditionalConfirmationPage extends StatelessWidget {
  static const routeName = '/additional_complete';
  const AdditionalConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileFrame(
        child: Stack(
          children: [
            // 배경 diagonal
            Positioned.fill(
              child: CustomPaint(
                painter: DiagonalPainter(color: const Color(0xFFEADFCB)),
              ),
            ),

            // 메인 타이틀
            const Positioned(
              left: 110,
              top: 95,
              child: Text(
                '추가 주문 완료',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.60,
                ),
              ),
            ),

            // 서브 텍스트
            const Positioned(
              left: 87,
              top: 140,
              child: Text(
                '계좌이체까지 해주셔야 주문이 완료됩니다.\n계좌번호: KB국민은행 93800201556124 심태윤',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.40,
                ),
              ),
            ),

            // 로고 또는 아이콘
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/publogo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.local_bar,
                    size: 100,
                    color: Colors.black26,
                  ),
                ),
              ),
            ),

            // 추가 주문 버튼 (하단 중앙)
            Positioned(
              left: 30,
              right: 30,
              bottom: 60,
              child: SizedBox(
                height: 65,
                child: Material(
                  color: const Color(0xFF8D1C3D),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.pushNamed(context, '/additional_menu'),
                    child: const Center(
                      child: Text(
                        '추가 주문',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
