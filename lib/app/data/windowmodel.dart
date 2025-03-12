class WindowModel {
  final int id; // id is now required (non-nullable)
  final int userId;
  final String name;
  final double height;
  final double width;

  WindowModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.height,
    required this.width,
  });

  factory WindowModel.fromJson(Map<String, dynamic> json) {
    return WindowModel(
      id: json['id'], // Ensure this is always set
      userId: json['user_id'],
      name: json['name'],
      height: (json['height'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId, // Do not include `id` when inserting
      'name': name,
      'height': height,
      'width': width,
    };
  }
}
