// lib/screens/additional_cart_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';
import 'package:jujeom_app/services/reservation_service.dart';
import 'package:jujeom_app/services/api_service.dart';
import 'package:jujeom_app/services/api_service.dart' show TableReservation;

/// 추가 주문 후 보여지는 장바구니 페이지
class AdditionalCartPage extends StatelessWidget {
  static const routeName = '/additional_cart';
  const AdditionalCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ReservationService>();
    final cart = service.additionalCart;
    final total = service.additionalTotalAmount ;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileFrame(
        child: Stack(
          children: [
            // Gray bottom sheet
            Positioned(
              left: 0,
              top: 261,
              child: Container(
                width: 393,
                height: 591,
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
            // Title
            const Positioned(
              left: 112,
              top: 55,
              child: Text(
                '추가 주문 내역',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  letterSpacing: -0.60,
                  color: Colors.black,
                ),
              ),
            ),
            // Back button
            Positioned(
              left: 30,
              top: 54,
              child: Material(
                color: const Color(0xFFECF0F4),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.pushNamed(context, '/additional_menu'),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.arrow_back, color: Colors.black54),
                  ),
                ),
              ),
            ),
            // Logo placeholder
            Positioned(
              left: 0,
              right: 0,
              top: 110,
              child: Center(
                child: Image.asset(
                  'assets/publogo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.local_bar,
                    size: 100,
                    color: Colors.black26,
                  ),
                ),
              ),
            ),
            // Cart items list
            Positioned(
              left: 35,
              top: 326,
              right: 30,
              bottom: 200,
              child: ListView.separated(
                itemCount: cart.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final ci = cart[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              ci.item.name,
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                letterSpacing: -0.40,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () => service.decrementAdditional(index),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.remove, size: 20, color: Color(0xFF464646)),
                                ),
                              ),
                              Text(
                                '${ci.quantity}',
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  letterSpacing: -0.60,
                                  color: Color(0xFF464646),
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () => service.incrementAdditional(index),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.add, size: 20, color: Color(0xFF464646)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ci.item.price}원',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          letterSpacing: -0.24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Total amount label
            Positioned(
              left: 35,
              top: 689,
              child: Text(
                '총 금액',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: -0.40,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              left: 280,
              top: 689,
              child: Text(
                '${service.additionalTotalAmount}원',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: -0.60,
                  color: Color(0xFF464646),
                ),
              ),
            ),
            // 추가 주문 완료 버튼 (테이블 번호 입력 팝업)
            Positioned(
              left: 31,
              top: 741,
              child: SizedBox(
                width: 332,
                height: 65,
                child: Material(
                  color: service.additionalTotalAmount  > 0 ? const Color(0xFF8D1C3D) : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    // 다이얼로그 호출 부분만 발췌
                    onTap: service.additionalTotalAmount > 0
                        ? () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                String inputTable = '';
                                TableReservation? result;
                                bool loading = false;
                                bool submitLoading = false;
                                String? error;

                                return StatefulBuilder(
                                  builder: (ctx, setState) => Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    child: Container(
                                      color: Colors.white,
                                      width: 320,
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // — 상단: 제목 + 닫기 버튼
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '테이블 조회',
                                                style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => Navigator.pop(ctx),
                                                child: const Icon(Icons.close, size: 20),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 12),

                                          // — 테이블 번호 입력 + 조회
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText: '테이블 번호',
                                                    errorText: error,
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                  ),
                                                  onChanged: (v) => setState(() {
                                                    inputTable = v.trim();
                                                    result = null;
                                                    error = null;
                                                  }),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                height: 40,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFFD9D9D9),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  ),
                                                  onPressed: (inputTable.isNotEmpty && !loading)
                                                      ? () async {
                                                          setState(() { loading = true; error = null; });
                                                          try {
                                                            result = await ApiService().fetchTable(int.parse(inputTable));
                                                          } catch (_) {
                                                            error = '조회 실패';
                                                          } finally {
                                                            setState(() { loading = false; });
                                                          }
                                                        }
                                                      : null,
                                                  child: loading
                                                      ? const SizedBox(
                                                          width: 16, height: 16,
                                                          child: CircularProgressIndicator(strokeWidth: 2))
                                                      : const Icon(Icons.search, size: 20, color: Colors.black54),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // — 조회 결과
                                          if (result != null) ...[
                                            const SizedBox(height: 16),
                                            const Divider(),
                                            const SizedBox(height: 12),
                                            if (result!.hasReservation) ...[
                                              Text(
                                                '예약자: ${result!.name}',
                                                style: const TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 16),

                                              // “확인” 버튼 하나
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFFD9D9D9),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                  ),
                                                  onPressed: !submitLoading 
                                                      ? () async {
                                                          setState(() { submitLoading = true; });
                                                          try {
                                                            final ok = await service.submitAdditionalOrder(
                                                              tableNo: result!.tableNumber,
                                                            );
                                                            if (ok) {
                                                              Navigator.pushNamedAndRemoveUntil(
                                                                context, '/additional_complete', (r) => false);
                                                            }
                                                          } finally {
                                                            setState(() { submitLoading = false; });
                                                          }
                                                        }
                                                      : null,
                                                  child: submitLoading
                                                      ? const SizedBox(
                                                          width: 16, 
                                                          height: 16,
                                                          child: CircularProgressIndicator(strokeWidth: 2)
                                                        )
                                                      : const Text(
                                                          '확인',
                                                          style: TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ] else ...[
                                              Text(
                                                '예약이 없습니다.',
                                                style: const TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 14,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        : null,

                    child: Center(
                      child: Text(
                        '추가 주문 완료',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          letterSpacing: -0.40,
                          color: service.additionalTotalAmount > 0
                              ? Colors.white
                              : Colors.black38,
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
