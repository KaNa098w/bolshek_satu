// Модель верхнего уровня
class NotificationsResponse {
  final List<NotificationsItem> items;
  final int total;

  NotificationsResponse({
    required this.items,
    required this.total,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => NotificationsItem.fromJson(item))
          .toList(),
      total: json['total'],
    );
  }
}

// Модель для каждого элемента items
class NotificationsItem {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String? readedAt;
  final Data data;
  final String scheduledAt;

  final List<dynamic> failures;
  final Recipient recipient;

  NotificationsItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.readedAt,
    required this.data,
    required this.scheduledAt,
    required this.failures,
    required this.recipient,
  });

  factory NotificationsItem.fromJson(Map<String, dynamic> json) {
    return NotificationsItem(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      readedAt: json['readedAt'],
      data: Data.fromJson(json['data']),
      scheduledAt: json['scheduledAt'],
      // Если поля failures отсутствуют, возвращаем пустой список
      failures: json['failures'] ?? [],
      recipient: Recipient.fromJson(json['recipient']),
    );
  }
}

// Модель для data
class Data {
  final String type;
  final String orderId;

  Data({
    required this.type,
    required this.orderId,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      type: json['type'],
      orderId: json['orderId'],
    );
  }
}

// Модель для recipient
class Recipient {
  final String type;
  final String userId;

  Recipient({
    required this.type,
    required this.userId,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      type: json['type'],
      userId: json['userId'],
    );
  }
}
