class GiftModel {
  final int totalCustomerScore;
  final List<GiftItem> value;

  GiftModel({
    required this.totalCustomerScore,
    required this.value,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      totalCustomerScore: json['total_customer_score'] ?? 0,
      value: (json['value'] as List<dynamic>?)
              ?.map((e) => GiftItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class GiftItem {
  final String totalWarehouseGiftQuantity;
  final String chuaDuyet;
  final String daDuyet;
  final String id;
  final String name;
  final String img;
  final String description;
  final String score;
  final String type;
  final String isActive;
  final String createdBy;
  final String updateAt;
  final String modifiedBy;

  GiftItem({
    required this.totalWarehouseGiftQuantity,
    required this.chuaDuyet,
    required this.daDuyet,
    required this.id,
    required this.name,
    required this.img,
    required this.description,
    required this.score,
    required this.type,
    required this.isActive,
    required this.createdBy,
    required this.updateAt,
    required this.modifiedBy,
  });

  factory GiftItem.fromJson(Map<String, dynamic> json) {
    return GiftItem(
      totalWarehouseGiftQuantity: json['total_warehouse_gift_quantity'] ?? '',
      chuaDuyet: json['chua_duyet'] ?? '',
      daDuyet: json['da_duyet'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      description: json['description'] ?? '',
      score: json['score'] ?? '',
      type: json['type'] ?? '',
      isActive: json['is_active'] ?? '',
      createdBy: json['created_by'] ?? '',
      updateAt: json['update_at'] ?? '',
      modifiedBy: json['modified_by'] ?? '',
    );
  }
}
