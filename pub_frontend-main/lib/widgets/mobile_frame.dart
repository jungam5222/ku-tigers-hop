import 'package:flutter/material.dart';

/// 모바일 디자인 크기를 유지하며
/// 데스크탑에서는 중앙에 예쁘게 정렬해 주는 래퍼 위젯
class MobileFrame extends StatelessWidget {
  final Widget child;
  final double designWidth;
  final double designHeight;

  const MobileFrame({
    super.key,
    required this.child,
    this.designWidth = 393,
    this.designHeight = 852,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey.shade200,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: designWidth,
            height: designHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      ),
    );
  }
}
