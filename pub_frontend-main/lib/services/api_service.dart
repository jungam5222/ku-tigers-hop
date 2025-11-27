// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jujeom_app/models/menu_item.dart';
import 'package:jujeom_app/models/waiting_queue.dart';

class ApiService {
  /// Railway에 배포된 백엔드 기본 URL
  static const String baseUrl =
      'https://ku-tigers-hop-backend-production.up.railway.app';

  /// 메뉴 목록
  Future<List<MenuItem>> fetchMenuItems() async {
    // urls.py: path('api/menu/', views.get_menu, ...)
    final res = await http.get(Uri.parse('$baseUrl/api/menu/'));
    if (res.statusCode != 200) {
      throw Exception('메뉴 로드 실패: ${res.statusCode}');
    }
    final list = jsonDecode(utf8.decode(res.bodyBytes)) as List;
    return list
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 추가 메뉴가 따로 있는 엔드포인트는 아직 없음
  /// 필요하면 백엔드에 path('api/additional-menu/', ...)를 새로 만들고 나서 열자.
  Future<List<MenuItem>> fetchAdditionalMenuItems() async {
    // 일단은 기존 메뉴를 그대로 쓰게 임시 구현하거나, 아예 사용 안 하게 막아도 됨.
    final res = await http.get(Uri.parse('$baseUrl/api/menu/'));
    if (res.statusCode != 200) {
      throw Exception('추가 메뉴 로드 실패: ${res.statusCode}');
    }
    final list = jsonDecode(utf8.decode(res.bodyBytes)) as List;
    return list
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 대기열 정보
  Future<WaitingQueue> fetchWaitingQueue() async {
    // urls.py: path('api/waiting-queue/', views.get_waiting_queue, ...)
    final res = await http.get(Uri.parse('$baseUrl/api/waiting-queue/'));
    if (res.statusCode != 200) {
      throw Exception('대기열 정보 로드 실패: ${res.statusCode}');
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return WaitingQueue.fromJson(json);
  }

  /// 첫 예약 + 주문 전송
// lib/services/api_service.dart 안

Future<void> sendReservation(Map<String, dynamic> reservationData) async {
  final url = Uri.parse('${ApiService.baseUrl}/reservation/');
  print('[ApiService] POST $url');
  print('[ApiService] body = ${jsonEncode(reservationData)}');

  final response = await http.post(
    url,
    headers: const {'Content-Type': 'application/json'},
    body: jsonEncode(reservationData),
  );

  print('[ApiService] status = ${response.statusCode}');
  print('[ApiService] response body = ${response.body}');

  if (response.statusCode == 201) {
    if (!kReleaseMode) {
      print('[ApiService] Reservation sent successfully');
    }
  } else {
    throw Exception('Failed to send reservation: ${response.body}');
  }
}

  /// 추가 주문 전송
  Future<void> sendMenuItems(Map<String, dynamic> additionalOrderData) async {
    // urls.py: path('menu-items/', views.add_menu_items, ...)
    final url = Uri.parse('$baseUrl/menu-items/');
    final response = await http.post(
      url,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(additionalOrderData),
    );

    if (response.statusCode == 201) {
      if (!kReleaseMode) {
        print('Menu items sent successfully');
      }
    } else {
      throw Exception('Failed to send menu items: ${response.body}');
    }
  }
}

/// 테이블 예약 조회용 모델
class TableReservation {
  final String tableNumber;
  final bool hasReservation;
  final String? name;
  final String? message;

  TableReservation({
    required this.tableNumber,
    required this.hasReservation,
    this.name,
    this.message,
  });

  factory TableReservation.fromJson(Map<String, dynamic> json) {
    return TableReservation(
      tableNumber: json['table_number'] as String,
      hasReservation: json['has_reservation'] as bool,
      name: json['name'] as String?,
      message: json['message'] as String?,
    );
  }
}

/// ApiService 확장: 테이블 정보 조회
extension ApiServiceTable on ApiService {
  Future<TableReservation> fetchTable(int tableNo) async {
    final url =
        Uri.parse('${ApiService.baseUrl}/api/table/$tableNo/');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('테이블 조회 실패: ${res.statusCode}');
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return TableReservation.fromJson(json);
  }
}
