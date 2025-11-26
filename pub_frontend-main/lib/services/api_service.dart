import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jujeom_app/models/menu_item.dart';
import 'package:jujeom_app/models/waiting_queue.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  //static const String baseUrl = 'https://pub-api.kucse.kr';
  // 또는 Railway:
  static const String baseUrl = 'https://ku-tigers-hop-backend-production.up.railway.app';

  Future<List<MenuItem>> fetchMenuItems() async {
    final res = await http.get(Uri.parse('$baseUrl/api/menu'));
    if (res.statusCode != 200) {
      throw Exception('메뉴 로드 실패: ${res.statusCode}');
    }
    final list = jsonDecode(utf8.decode(res.bodyBytes)) as List;
    return list
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MenuItem>> fetchAdditionalMenuItems() async {
    final res = await http.get(Uri.parse('$baseUrl/api/additional-menu'));
    if (res.statusCode != 200) {
      throw Exception('추가 메뉴 로드 실패: ${res.statusCode}');
    }
    final list = jsonDecode(utf8.decode(res.bodyBytes)) as List;
    return list
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WaitingQueue> fetchWaitingQueue() async {
    final res = await http.get(Uri.parse('$baseUrl/api/waiting-queue/'));
    if (res.statusCode != 200) {
      throw Exception('대기열 정보 로드 실패: ${res.statusCode}');
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return WaitingQueue.fromJson(json);
  }

  Future<void> sendReservation(Map<String, dynamic> reservationData) async {
    final url = Uri.parse('$baseUrl/reservation/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reservationData),
    );

    if (response.statusCode == 201) {
      print('Reservation sent successfully');
    } else {
      throw Exception('Failed to send reservation: ${response.body}');
    }
  }

  Future<void> sendMenuItems(Map<String, dynamic> additionalOrderData) async {
    final url = Uri.parse('$baseUrl/menu-items/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(additionalOrderData),
    );

    if (response.statusCode == 201) {
      print('Menu items sent successfully');
    } else {
      throw Exception('Failed to send menu items: ${response.body}');
    }
  }
}

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

extension ApiServiceTable on ApiService {
  Future<TableReservation> fetchTable(int tableNo) async {
    // 🔥 여기서 ApiService.baseUrl 사용
    final url = Uri.parse('${ApiService.baseUrl}/api/table/$tableNo/');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('테이블 조회 실패: ${res.statusCode}');
    }
    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return TableReservation.fromJson(json);
  }
}
