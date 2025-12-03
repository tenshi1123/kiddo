class LichthiModel {
  final List<CoSoModel> cosos;
  final List<ValueModel> values;
  final List<LichCuaToiModels> lichCuaToi;
  LichthiModel({
    required this.cosos,
    required this.values,
    required this.lichCuaToi,
  });
  factory LichthiModel.fromJson(Map<String, dynamic> json) {
    return LichthiModel(
      cosos:
          ((json['coso'] as List).map((e) => CoSoModel.fromJson(e)).toList()),
      values:
          ((json['value'] as List).map((e) => ValueModel.fromJson(e)).toList()),
      lichCuaToi: ((json['lich_thi_cua_toi'] as List)
          .map((e) => LichCuaToiModels.fromJson(e))
          .toList()),
    );
  }
}

class CoSoModel {
  final String id;
  final String name;
  final String address;
  final String isActive;
  CoSoModel({
    required this.id,
    required this.name,
    required this.address,
    required this.isActive,
  });
  factory CoSoModel.fromJson(Map<String, dynamic> json) {
    return CoSoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? '',
    );
  }
}

class ValueModel {
  final String cosoName;
  final String cosoAddress;
  final String typeName;
  final String id;
  final String cosoId;
  final String name;
  final String description;
  final String img;
  final String type;
  final String day;
  final String price;
  final String isActive;
  final String createdAt;
  final String updatedAt;
  ValueModel({
    required this.cosoName,
    required this.cosoAddress,
    required this.typeName,
    required this.id,
    required this.cosoId,
    required this.name,
    required this.description,
    required this.img,
    required this.type,
    required this.day,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  factory ValueModel.fromJson(Map<String, dynamic> json) {
    return ValueModel(
      cosoName: json['coso_name'] ?? '',
      cosoAddress: json['coso_address'] ?? '',
      typeName: json['type_name'] ?? '',
      id: json['id'] ?? '',
      cosoId: json['coso_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      img: json['img'] ?? '',
      type: json['type'] ?? '',
      day: json['day'] ?? '',
      price: json['price'] ?? '',
      isActive: json['is_active'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['update_at'] ?? '',
    );
  }
}

class LichCuaToiModels {
  final String id;
  final String cosoName;
  final String cosoAddress;
  final String name;
  final String description;
  final String day;
  final String typeName;
  final String score;
  LichCuaToiModels(
      {required this.id,
      required this.cosoName,
      required this.cosoAddress,
      required this.name,
      required this.description,
      required this.day,
      required this.typeName,
      required this.score});
  factory LichCuaToiModels.fromJson(Map<String, dynamic> json) {
    return LichCuaToiModels(
      id: json['id'] ?? '',
      cosoName: json['coso_name'] ?? '',
      cosoAddress: json['coso_address'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      day: json['day'] ?? '',
      typeName: json['type_name'] ?? '',
      score: json['score'] ?? '',
    );
  }
}
