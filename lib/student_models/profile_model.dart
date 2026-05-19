class ProfileModel {
  final String avatar;
  final String fullName;
  final String id;
  final String email;
  final String phone;
  final String gender;
  final String birthday;

  ProfileModel({
    required this.avatar,
    required this.fullName,
    required this.id,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthday,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      avatar: json['avatar'] ?? '',
      fullName: json['full_name'] ?? 'Không có dữ liệu',
      id: json['id'] ?? 'Không có dữ liệu',
      email: json['email'] ?? 'Không có dữ liệu',
      phone: json['phone'] ?? 'Không có dữ liệu',
      gender: json['gender'] ?? 'Không có dữ liệu',
      birthday: json['birthday'] ?? 'Không có dữ liệu',
    );
  }
}

class DetailPostModel {
  final String id;
  final String postTitle;
  final String postName;
  final String guid;
  final String postContent;
  final DateTime postDate;
  final String thumbnail;
  final String categories;

  DetailPostModel(
      {required this.id,
      required this.postTitle,
      required this.postName,
      required this.guid,
      required this.postContent,
      required this.postDate,
      required this.thumbnail,
      required this.categories});
  factory DetailPostModel.fromJson(Map<String, dynamic> json) {
    return DetailPostModel(
      id: json['ID'] ?? '',
      postTitle: json['post_title'] ?? '',
      postName: json['post_name'] ?? '',
      guid: json['guid'] ?? '',
      postContent: json['post_content'] ?? '',
      postDate: DateTime.parse(json['post_date'] ?? ''),
      thumbnail: json['thumbnail'] ?? '',
      categories: json['categories'] ?? '',
    );
  }
}

class NotiModel {
  final String id;
  final String title;
  final String content;
  final String link;
  final String customerId;
  final String createdAt;

  NotiModel({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    required this.customerId,
    required this.createdAt,
  });
  factory NotiModel.fromJson(Map<String, dynamic> json) {
    return NotiModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      link: json['link'] ?? '',
      customerId: json['customer_id'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class PaymentModel {
  final String title;
  final String orderId;
  final String amount;
  final String expiryDate;
  final String createDate;
  final String paymentMethodName;
  final String pendingPaymentId;
  final String status;
  final String createdAt;
  final String orderNote;

  PaymentModel({
    required this.title,
    required this.orderId,
    required this.amount,
    required this.expiryDate,
    required this.createDate,
    required this.paymentMethodName,
    required this.pendingPaymentId,
    required this.status,
    required this.createdAt,
    required this.orderNote,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      title: json['title'] ?? '',
      orderId: json['order_id'] ?? '',
      amount: json['amount'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      createDate: json['created_date'] ?? '',
      paymentMethodName: json['payment_method_name'] ?? '',
      pendingPaymentId: json['pending_payment_id'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      orderNote: json['order_note'] ?? '',
    );
  }
}

class PaymentDetailModel {
  final String pendingPaymentId;
  final String orderId;
  final String amount;
  final String linkQr;

  PaymentDetailModel({
    required this.pendingPaymentId,
    required this.orderId,
    required this.amount,
    required this.linkQr,
  });
  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return PaymentDetailModel(
      pendingPaymentId: json['pending_payment_id'] ?? '',
      orderId: json['order_id'] ?? '',
      amount: json['amount'] ?? '',
      linkQr: json['link_qr'] ?? '',
    );
  }
}

class GopYModel {
  final String id;
  final String topic;
  final String content;
  final String createdAt;
  GopYModel({
    required this.id,
    required this.topic,
    required this.content,
    required this.createdAt,
  });
  factory GopYModel.fromJson(Map<String, dynamic> json) {
    return GopYModel(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
