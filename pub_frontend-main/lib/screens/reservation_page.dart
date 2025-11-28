// lib/screens/reservation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';
import 'package:jujeom_app/services/reservation_service.dart';

class ReservationPage extends StatefulWidget {
  static const routeName = '/reservation';
  const ReservationPage({super.key});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  // 처음에는 선택된 시간이 없도록 0으로 초기화
  int _selectedDuration = 1;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = context.watch<ReservationService>();
    nameController.text = service.name;
    phoneController.text = service.phone;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ReservationService>();
    final quantity = service.reservationCount;
    final isFormValid =
        service.name.trim().isNotEmpty && service.phone.trim().isNotEmpty;
    // minOrder는 service.minOrder로 대체
    final minOrder = service.minOrder;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileFrame(
        child: Stack(
          children: [
            // 제목
            const Positioned(
              left: 0, top: 59, right: 0,
              child: Text(
                '예약하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.60,
                  color: Colors.black,
                ),
              ),
            ),

            // 로고
            Positioned(
              left: 0, right: 0, top: 110,
              child: Center(
                child: Image.asset(
                  'assets/publogo.png',
                  width: 120, height: 120, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.local_bar, size: 60, color: Colors.black26),
                ),
              ),
            ),

            // 하단 시트
            Positioned(
              left: 0, top: 260,
              child: Container(
                width: screenW, height: 600,
                decoration: const ShapeDecoration(
                  color: Color(0xFFEADFCB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                ),
              ),
            ),

            // 이름
            const Positioned(
              left: 38, top: 320,
              child: Text(
                '이름',
                style: TextStyle(
                  fontSize: 14, fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600, letterSpacing: -0.42,
                  color: Color(0xFF464646),
                ),
              ),
            ),
            Positioned(
              left: 30, top: 345,
              child: Container(
                width: 333, height: 65,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDBDBDB)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.person, color: Color(0xFFB9B9B9)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        onChanged: (v) => service.name = v,
                        decoration: const InputDecoration(
                          hintText: '이름을 입력해주세요',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14, fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB9B9B9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 전화번호
            const Positioned(
              left: 38, top: 420,
              child: Text(
                '전화번호',
                style: TextStyle(
                  fontSize: 14, fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600, letterSpacing: -0.42,
                  color: Color(0xFF464646),
                ),
              ),
            ),
            Positioned(
              left: 30, top: 445,
              child: Container(
                width: 333, height: 65,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDBDBDB)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.phone, color: Color(0xFFB9B9B9)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          // 숫자만 허용
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          // (선택) 최대 길이 제한, 예: 11자리
                          LengthLimitingTextInputFormatter(11),
                        ],
                        onChanged: (v) => service.phone = v,
                        decoration: const InputDecoration(
                          hintText: '전화번호를 입력해주세요',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14, 
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB9B9B9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 인원
            const Positioned(
              left: 38, top: 530,
              child: Text(
                '인원',
                style: TextStyle(
                  fontSize: 14, fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600, letterSpacing: -0.42,
                  color: Color(0xFF464646),
                ),
              ),
            ),
            Positioned(
              left: 30, top: 555,
              child: Container(
                width: 120, height: 50,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDBDBDB)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 감소 버튼 (1명 미만으로 내려가지 않음)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: quantity > 1
                          ? () => service.setReservationCount(quantity - 1)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: quantity > 1
                              ? const Color(0xFF464646)
                              : const Color(0xFFBDBDBD),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 20, fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600, color: Color(0xFF464646),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 증가 버튼 (7명 초과하지 않도록)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: quantity < 7
                          ? () => service.setReservationCount(quantity + 1)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: quantity < 7
                              ? const Color(0xFF464646)
                              : const Color(0xFFBDBDBD),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 시간 선택: 초기엔 둘 다 비활성화 (0)
//            Positioned(
//              left: 30, right: 30, top: 635,
//              child: Row(
//                children: [
//                  Expanded(
//                    child: GestureDetector(
//                      onTap: () {
//                        setState(() => _selectedDuration = 60);
//                        service.setMinOrder(25000);
//                        service.setDuration(60);
//                      },
//                      child: Container(
//                        height: 50,
//                        decoration: BoxDecoration(
//                          color: _selectedDuration == 60
//                              ? Colors.white
//                              : const Color(0xFFEEEEEE),
//                          border: Border.all(
//                            color: _selectedDuration == 60
//                                ? const Color(0xFFBBBBBB)
//                                : const Color(0xFFDBDBDB),
//                          ),
//                          borderRadius: BorderRadius.circular(16),
//                        ),
//                        child: Center(
//                          child: Text(
//                            '60분',
//                            style: TextStyle(
//                              fontSize: 18, fontWeight: FontWeight.w700,
//                              color: _selectedDuration == 60
//                                  ? Colors.black
//                                  : const Color(0xFF777777),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                  const SizedBox(width: 12),
//                  Expanded(
//                    child: GestureDetector(
//                      onTap: () {
//                        setState(() => _selectedDuration = 90);
//                        service.setMinOrder(40000);
//                        service.setDuration(90);
//                      },
//                      child: Container(
//                        height: 50,
//                        decoration: BoxDecoration(
//                          color: _selectedDuration == 90
//                              ? Colors.white
//                              : const Color(0xFFEEEEEE),
//                          border: Border.all(
//                            color: _selectedDuration == 90
//                                ? const Color(0xFFBBBBBB)
//                                : const Color(0xFFDBDBDB),
//                          ),
//                          borderRadius: BorderRadius.circular(16),
//                        ),
//                        child: Center(
//                          child: Text(
//                            '90분',
//                            style: TextStyle(
//                              fontSize: 18, fontWeight: FontWeight.w700,
//                              color: _selectedDuration == 90
//                                  ? Colors.black
//                                  : const Color(0xFF777777),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),

            // 최소 주문금액
            if (_selectedDuration != 0)
              Positioned(
                left: 0, right: 0, top: 700,
                child: Text(
                  '최소 주문금액: 없음.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600, color: Color(0xFF333333),
                  ),
                ),
              ),

            // 다음 버튼
            Positioned(
              left: 31, top: 745,
              child: SizedBox(
                width: 332, height: 65,
                child: ElevatedButton(
                  onPressed: isFormValid
                      ? () => Navigator.pushNamed(context, '/menu')
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFormValid ? const Color(0xFF8D1C3D) : const Color(0xFFEEEEEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '다음',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20, fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w800,
                      color: isFormValid
                          ? Colors.white
                          : Colors.black38,
                      letterSpacing: -0.40,
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
