// lib/screens/confirmation_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';
import 'package:jujeom_app/services/reservation_service.dart';
import 'package:jujeom_app/services/api_service.dart';
import 'package:jujeom_app/models/waiting_queue.dart';

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

class ConfirmationPage extends StatefulWidget {
  static const routeName = '/complete';
  const ConfirmationPage({super.key});

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  late Future<WaitingQueue> _queueFuture;

  @override
  void initState() {
    super.initState();
    _queueFuture = ApiService().fetchWaitingQueue();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ReservationService>();
    final hasConfirmed = service.hasConfirmed;

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
              left: 91,
              top: 95,
              child: Text(
                '예약 및 주문 완료',
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
              left: 60,
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

            // 확정 여부에 따른 추가 주문 버튼
            if (hasConfirmed)
              Positioned(
                left: 30,
                top: 743,
                child: SizedBox(
                  width: 333,
                  height: 65,
                  child: Material(
                    color: const Color(0xFF8D1C3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
              )
            else
              // 대기 팀 정보는 API를 통해 동적으로 가져오기
              Positioned(
                left: 0,
                right: 0,
                bottom: 60,
                child: FutureBuilder<WaitingQueue>(
                  future: _queueFuture,
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(
                        child: Text(
                          '대기열 로드 실패: ${snap.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    final wq = snap.data!;
                    return Center(
                      child: Text(
                        '현재 대기 팀: ${wq.queueLength}팀\n'
                        '예상 대기시간: ${wq.estimatedWaitMinutes}분',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.40,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
