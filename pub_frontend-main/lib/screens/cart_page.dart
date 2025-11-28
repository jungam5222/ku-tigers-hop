// lib/screens/cart_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';
import 'package:jujeom_app/services/reservation_service.dart';
import 'package:jujeom_app/screens/confirmation_page.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart';
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ReservationService>();
    final cart = service.cart;
    final total = service.totalAmount;
    final minOrder = service.minOrder;
    final duration = service.duration;

    final formatter = NumberFormat('#,###');

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
              left: 145,
              top: 59,
              child: Text(
                '장바구니',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.60,
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
                  onTap: () => Navigator.pushNamed(context, '/menu'),
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
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.40,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () => service.decrement(index),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.remove,
                                      size: 20, color: Color(0xFF464646)),
                                ),
                              ),
                              Text(
                                '${ci.quantity}',
                                style: const TextStyle(
                                  color: Color(0xFF464646),
                                  fontSize: 20,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.60,
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () => service.increment(index),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.add,
                                      size: 20, color: Color(0xFF464646)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatter.format(ci.item.price)}원',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // 테이블비 고정 항목
            Positioned(
              left: 35,
              top: 661,
              child: Text(
                '테이블비',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.40,
                ),
              ),
            ),
            Positioned(
              left: 280,
              top: 661,
              child: Text(
                '인당 3,000원',
                style: const TextStyle(
                  color: Color(0xFF464646),
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.60,
                ),
              ),
            ),

            // 총 금액
            Positioned(
              left: 35,
              top: 700,
              child: Text(
                '총 금액',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.40,
                ),
              ),
            ),
            Positioned(
              left: 280,
              top: 700,
              child: Text(
                '${formatter.format(total)}원',
                style: const TextStyle(
                  color: Color(0xFF464646),
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.60,
                ),
              ),
            ),
            // Order button with backend submit
            Positioned(
              left: 31,
              top: 741,
              child: SizedBox(
                width: 332,
                height: 65,
                child: Material(
                  color: !_isSubmitting
                      ? const Color(0xFF8D1C3D)
                      : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: !_isSubmitting
                        ? () async {
                            setState(() => _isSubmitting = true);
                            try {
                              final success = await service.submitInitialOrder(
                                name: service.name,
                                phone: service.phone,
                                reservationCount: service.reservationCount,
                                duration: duration, // 전달
                              );
                              if (success) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  ConfirmationPage.routeName,
                                  (route) => false,
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isSubmitting = false);
                            }
                          }
                        : null,
                    child: Center(
                      child: _isSubmitting 
                         ? const CircularProgressIndicator()
                         : Text(
                            '주문하기',
                            style: TextStyle(
                              color: !_isSubmitting
                                  ? Colors.white
                                  : Colors.black38,
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
