// lib/models/waiting_queue.dart
class WaitingQueue {
  final int queueLength;
  final int estimatedWaitMinutes;

  WaitingQueue({
    required this.queueLength,
    required this.estimatedWaitMinutes,
  });

  factory WaitingQueue.fromJson(Map<String, dynamic> json) {
    return WaitingQueue(
      queueLength: json['queue_length'] as int,
      estimatedWaitMinutes: json['estimated_wait_minutes'] as int,
    );
  }
}
