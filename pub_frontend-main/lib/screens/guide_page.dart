import 'package:flutter/material.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';

class GuidePage extends StatefulWidget {
  static const routeName = '/guide';
  final List<String> guideTexts;
  const GuidePage({
    super.key,
    this.guideTexts = const [
      '계좌이체까지 꼭 완료해주셔야 주문이 완료됩니다.',
      '과음 등 안전에 항상 주의해주시길 바랍니다.',
      '추가 문의사항은 직원에게 문의 바랍니다.',
    ],
  });

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List<bool>.filled(widget.guideTexts.length, false);
  }

  bool get _allChecked => _checked.every((c) => c);

  void _onNextTap() {
    if (_allChecked) Navigator.pushNamed(context, '/reservation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileFrame(
        child: Stack(
          children: [
            Positioned(
              left: 130, top: 59,
              child: const Text(
                '이용 가이드',
                style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w800,
                  fontFamily: 'Pretendard', letterSpacing: -0.6,
                  color: Colors.black,
                ),
              ),
            ),

            // 가이드 박스 + 체크
            for (int i = 0; i < widget.guideTexts.length; i++) ...[
              Positioned(
                left: 30, top: 154 + i * 171,
                child: Container(
                  width: 333, height: 100,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEADFCB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.guideTexts[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        fontFamily: 'Pretendard', letterSpacing: -0.4,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 41, top: 271 + i * 171,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () => setState(() => _checked[i] = !_checked[i]),
                    child: Container(
                      width: 21, height: 21,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF333333)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _checked[i]
                          ? const Icon(Icons.check, size: 18, color: Color(0xFF333333))
                          : null,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 72, top: 272 + i * 171,
                child: const Text(
                  '확인했습니다',
                  style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard', letterSpacing: -0.34,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],

            Positioned(
              left: 30, top: 743,
              child: SizedBox(
                width: 333, height: 65,
                child: Material(
                  color: _allChecked ? const Color(0xFF8D1C3D) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _allChecked ? _onNextTap : null,
                    child: const Center(
                      child: Text(
                        '다음',
                        style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800,
                          fontFamily: 'Pretendard', letterSpacing: -0.4,
                          color: Colors.white,
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
