// lib/screens/welcome_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';
import 'package:jujeom_app/services/api_service.dart';
import 'package:jujeom_app/models/waiting_queue.dart';

/// 대각선 회색 영역을 그리는 커스텀 페인터
class TopRegionPainter extends CustomPainter {
  final Color color;
  TopRegionPainter({required this.color});

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

class WelcomePage extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Future<WaitingQueue> _queueFuture;

  @override
  void initState() {
    super.initState();
    _queueFuture = ApiService().fetchWaitingQueue();
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) return '${hours}시간 ${mins}분';
    if (hours > 0) return '${hours}시간';
    return '${mins}분';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileFrame(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: TopRegionPainter(color: const Color(0xFFD9D9D9)),
              ),
            ),

            // ① API 로딩 / 에러 / 정상 데이터 렌더링
            FutureBuilder<WaitingQueue>(
              future: _queueFuture,
              builder: (context, snap) {
                Widget content;
                if (snap.connectionState != ConnectionState.done) {
                  content = const Center(child: CircularProgressIndicator());
                } else if (snap.hasError) {
                  content = Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '대기열 정보 로드 실패:\n${snap.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  final wq = snap.data!;
                  content = Column(
                    children: [
                      const SizedBox(height: 95),
                      Text(
                        '현재 대기 팀: ${wq.queueLength}팀',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Pretendard',
                          letterSpacing: -0.60,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '예상 대기 시간: ${_formatDuration(wq.estimatedWaitMinutes)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                          letterSpacing: -0.40,
                        ),
                      ),
                    ],
                  );
                }

                return Positioned(
                  top: 0, left: 0, right: 0,
                  child: content,
                );
              },
            ),

            // ② 중앙 로고
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/publogo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.local_bar, size: 100, color: Colors.black26),
                ),
              ),
            ),

            // ③ 예약하기 버튼
            Positioned(
              left: 30,
              top: 743,
              child: SizedBox(
                width: 333,
                height: 65,
                child: Material(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // 예약 로직이 있다면 여기에 호출
                      // 예: Provider.of<ReservationService>(context, listen: false).reserveTeam();
                      Navigator.pushNamed(context, '/guide');
                    },
                    child: const Center(
                      child: Text(
                        '예약하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Pretendard',
                          letterSpacing: -0.40,
                          color: Color(0xFF333333),
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
