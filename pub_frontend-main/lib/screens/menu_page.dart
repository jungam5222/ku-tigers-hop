// lib/screens/menu_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jujeom_app/widgets/mobile_frame.dart';
import 'package:jujeom_app/screens/cart_page.dart';
import 'package:jujeom_app/services/reservation_service.dart';
import 'package:intl/intl.dart';
import 'package:jujeom_app/models/menu_item.dart';
import 'package:jujeom_app/services/api_service.dart';

class MenuPage extends StatefulWidget {
  static const routeName = '/menu';
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<MenuItem>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _menuFuture = ApiService().fetchMenuItems();
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: double.infinity,
        height: 132,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      path,
      width: double.infinity,
      height: 132,
      fit: BoxFit.cover,
    );
  }

  void _showCartPopup(BuildContext context, ReservationService service) {
    final formatter = NumberFormat('#,###');
    final cart = service.cart;
    showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              color: Colors.white,
              width: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '장바구니',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.60,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 각 CartItem
                  ...cart.map(
                    (ci) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              ci.item.name,
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.34,
                              ),
                            ),
                          ),
                          Text(
                            '×${ci.quantity}',
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.34,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  // ─── 테이블비 고정 항목 ─────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '테이블비',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.34,
                          ),
                        ),
                        Text(
                          '5,000원',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.34,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ────────────────────────────────────────────────
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '총 금액',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.40,
                        ),
                      ),
                      Text(
                        '${formatter.format(service.totalAmount)}원',
                        style: const TextStyle(
                          color: Color(0xFF464646),
                          fontSize: 18,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.60,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushNamed(context, CartPage.routeName);
                      },
                      child: const Text(
                        '장바구니로 이동',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ReservationService>();
    final cart = service.cart;
    final itemCount = cart.fold<int>(0, (sum, ci) => sum + ci.quantity);
    final formatter = NumberFormat.decimalPattern();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileFrame(
        child: FutureBuilder<List<MenuItem>>(
          future: _menuFuture,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('메뉴 로드 실패: ${snap.error}'));
            }
            final items = snap.data!;
            return Stack(
              children: [
                // Gray bottom sheet
                Positioned(
                  left: 0,
                  top: 261,
                  child: Container(
                    width: 393,
                    height: 591,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFD9D9D9),
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
                  left: 142,
                  top: 55,
                  child: Text(
                    '메뉴 주문',
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
                      onTap: () => Navigator.pushNamed(context, '/reservation'),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.arrow_back, color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                // Cart icon with badge
                Positioned(
                  right: 30,
                  top: 54,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Material(
                        color: const Color(0xFFD9D9D9),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _showCartPopup(context, service),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$itemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // 메뉴 리스트
                Positioned(
                  left: 30,
                  top: 140,
                  right: 30,
                  bottom: 0,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (ctx, idx) {
                      final menu = items[idx];
                      final names = menu.imageNames;
                      Widget imageWidget;
                      if (names.length > 1) {
                          // 2장짜리
                          imageWidget = ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: SizedBox(
                              height: 132,
                              child: Row(
                                children: names.map((fileName) {
                                  return Expanded(
                                    child: _buildImage('assets/$fileName'),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        } else {
                          // 단일 이미지
                          imageWidget = ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: _buildImage('assets/${names.first}'),
                          );
                        }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F525252),
                              blurRadius: 40,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageWidget,
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menu.name,
                                    style: const TextStyle(
                                      color: Color(0xFF181C2E),
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.60,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    menu.description,
                                    style: const TextStyle(
                                      color: Color(0xFFA0A5BA),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.40,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${formatter.format(menu.price)}원',
                                        style: const TextStyle(
                                          color: Color(0xFF181C2E),
                                          fontSize: 16,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Material(
                                        color: const Color(0xFFD9D9D9),
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () => service.addToCart(menu),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // 장바구니 이동 버튼
                if (itemCount > 0)
                  Positioned(
                    left: 31,
                    top: 741,
                    child: SizedBox(
                      width: 332,
                      height: 65,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                CartPage.routeName,
                              ),
                          child: const Center(
                            child: Text(
                              '장바구니로 이동',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
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
            );
          },
        ),
      ),
    );
  }
}
