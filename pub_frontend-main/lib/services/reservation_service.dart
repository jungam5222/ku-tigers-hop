// lib/services/reservation_service.dart
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:jujeom_app/services/api_service.dart';
import 'package:jujeom_app/models/menu_item.dart';

/// 전역 예약·주문 상태를 관리하는 ChangeNotifier 서비스
class ReservationService extends ChangeNotifier {
  /// 싱글톤 인스턴스
  static final ReservationService _instance = ReservationService._internal();
  factory ReservationService() => _instance;
  ReservationService._internal();

  /// 대기 팀 수
  int waitingTeams =
      int.tryParse(html.window.localStorage['waitingTeams'] ?? '0') ?? 0;

  /// 장바구니 목록
  List<CartItem> cart = [];
  List<CartItem> additionalCart = [];

  /// 테이블비
  static const int tableFee = 3000;

  /// 사용자 정보
  String name = '';
  String phone = '';

  /// 이름/전화번호 설정 (RESERVATION 화면에서 호출)
  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  /// 예약 인원 수
  int reservationCount = 1;

  /// 확정 완료 플래그
  bool hasConfirmed = false;

  /// 최소 주문 금액 (동적으로 변경)
  int _minOrder = 20000;
  int get minOrder => _minOrder;
  void setMinOrder(int value) {
    _minOrder = value;
    notifyListeners();
  }

  /// 예약 인원 설정
  void setReservationCount(int count) {
    reservationCount = count;
    notifyListeners();
  }

  /// 예약 페이지에서 팀 1 증가 (로컬 상태)
  void reserveTeam() {
    waitingTeams++;
    html.window.localStorage['waitingTeams'] = waitingTeams.toString();
    notifyListeners();
  }

  /// 관리자 확정 처리
  void confirmReservation() {
    hasConfirmed = true;
    notifyListeners();
  }

  /// 장바구니에 아이템 추가
  void addToCart(MenuItem item) {
    final idx = cart.indexWhere((ci) => ci.item.name == item.name);
    if (idx >= 0) {
      cart[idx].quantity++;
    } else {
      cart.add(CartItem(item: item));
    }
    waitingTeams++;
    notifyListeners();
  }

  /// 장바구니 수량 증가
  void increment(int idx) {
    cart[idx].quantity++;
    waitingTeams++;
    notifyListeners();
  }

  /// 장바구니 수량 감소 (1개면 제거)
  void decrement(int idx) {
    if (cart[idx].quantity > 1) {
      cart[idx].quantity--;
      waitingTeams--;
    } else {
      waitingTeams -= cart[idx].quantity;
      cart.removeAt(idx);
    }
    notifyListeners();
  }

  /// 장바구니 총액 계산 (메뉴 + 테이블비)
  int get totalAmount =>
      cart.fold(0, (sum, ci) => sum + ci.item.price * ci.quantity) + (tableFee * reservationCount);

  /// ── 추가 주문 전용 메서드들 ─────────────────────────────────

  /// 추가 장바구니에 아이템 추가
  void addToAdditionalCart(MenuItem item) {
    final idx = additionalCart.indexWhere((ci) => ci.item.id == item.id);
    if (idx >= 0) {
      additionalCart[idx].quantity++;
    } else {
      additionalCart.add(CartItem(item: item));
    }
    notifyListeners();
  }

  /// 추가 장바구니 수량 증가
  void incrementAdditional(int idx) {
    additionalCart[idx].quantity++;
    notifyListeners();
  }

  /// 추가 장바구니 수량 감소 (1개면 제거)
  void decrementAdditional(int idx) {
    if (additionalCart[idx].quantity > 1) {
      additionalCart[idx].quantity--;
    } else {
      additionalCart.removeAt(idx);
    }
    notifyListeners();
  }

  /// 추가 장바구니 총액 계산
  int get additionalTotalAmount =>
      additionalCart.fold(0, (sum, ci) => sum + ci.item.price * ci.quantity);

  /// 추가 장바구니 비우기
  void clearAdditionalCart() {
    additionalCart.clear();
    notifyListeners();
  }

  /// 첫 주문 전송 (예약 정보 + 메뉴)
  Future<bool> submitInitialOrder({
    required String name,
    required String phone,
    required int reservationCount,
    required int duration,
  }) async {
    // 첫 주문 데이터 생성
    final orderData = {
      'name': name,
      'phone': phone,
      'reservation_count': reservationCount,
      'duration': duration,
      'total_amount': totalAmount,
      'items': cart
          .map((ci) => {
                'name': ci.item.name,
                'quantity': ci.quantity,
                'price': ci.item.price,
              })
          .toList(),
    };

    try {
      print('[ReservationService] submitInitialOrder called');
      print('[ReservationService] orderData = $orderData');

      // ApiService를 사용해 첫 주문 데이터 전송
      final apiService = ApiService();
      await apiService.sendReservation(orderData);

      print('[ReservationService] sendReservation success');

      // 로컬 상태 업데이트
      html.window.localStorage['hasReserved'] = 'true';
      waitingTeams++;
      notifyListeners();
      return true;
    } catch (e, st) {
      print('[ReservationService] Failed to submit initial order: $e');
      print(st);
      return false;
    }
  }

 /// 추가 주문 전송 (메뉴 + 테이블 번호)
Future<bool> submitAdditionalOrder({String? tableNo}) async {
  final additionalOrderData = {
    'table_no': tableNo,
    'items': additionalCart
        .map((ci) => {
              'name': ci.item.name,
              'quantity': ci.quantity,
              'price': ci.item.price,
            })
        .toList(),
  };

  try {
    await ApiService().sendMenuItems(additionalOrderData);
    waitingTeams++;
    clearAdditionalCart();  // 전송 후 장바구니 비우기
    return true;
  } catch (e) {
    print('Failed to submit additional order: $e');
    return false;
  }
}


  /// 예약 시간 설정 (60/90분)
  int _duration = 0;
  int get duration => _duration;
  void setDuration(int value) {
    _duration = value;
    notifyListeners();
  }
}

/// CartItem 정의
class CartItem {
  final MenuItem item;
  int quantity;
  CartItem({required this.item, this.quantity = 1});
}
