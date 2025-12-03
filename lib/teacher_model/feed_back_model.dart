class FeedbackTermModel {
  final String id;
  final String customerId;
  final String fullName;
  final String phone;
  final String fullNameAlias;
  final String content;
  final String type;
  final String createdAt;
  FeedbackTermModel({
    required this.id,
    required this.customerId,
    required this.fullName,
    required this.phone,
    required this.fullNameAlias,
    required this.content,
    required this.type,
    required this.createdAt,
  });
  factory FeedbackTermModel.fromJson(Map<String, dynamic> json) {
    return FeedbackTermModel(
      id: json['id'] ?? '',
      customerId: json['customer_id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      fullNameAlias: json['full_name_alias'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
