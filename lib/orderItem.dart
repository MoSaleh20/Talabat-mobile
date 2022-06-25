import 'dart:convert';

OrderItem orderItemFromJson(String str) => OrderItem.fromJson(json.decode(str));

String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class OrderItem {
  OrderItem({
    this.orderId,
    this.restId,
    this.menuId,
    this.customerId,
    this.quantity,
    this.address,
    this.phone,
    this.price,
  });

  int orderId;
  int restId;
  int menuId;
  int customerId;
  int quantity;
  String address;
  String phone;
  double price;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderId: json["order_id"],
        restId: json["rest_id"],
        menuId: json["menu_id"],
        customerId: json["customer_id"],
        quantity: json["quantity"],
        address: json["address"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "rest_id": restId,
        "menu_id": menuId,
        "customer_id": customerId,
        "quantity": quantity,
        "address": address,
        "phone": phone,
      };
}
