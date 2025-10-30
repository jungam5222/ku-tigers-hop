// lib/models/menu_item.dart
class MenuItem {
  final int id;
  final String name;
  final String description;
  final int price;
  final String imageName;  // 나중에 API에 imagePath 필드가 추가되면 활용

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageName,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      imageName:    json['imageName']   as String,
    );
  }
  List<String> get imageNames => imageName.split(',');
}
