import 'package:flutter/material.dart';
import 'package:restaurant_app/restaurant.dart';

class MenuItem extends Restaurant {
  int menu_id;
  int rest_Id;
  String itemName;
  String itemDescription;
  int itemPrice;
  String iImage;
  Image itemImage;
  int itemRating;
  bool itemFavorite = false;
  bool itemOrdered = false;
  int quantity = 0;

  MenuItem(
      {this.menu_id,
      this.itemName,
      this.itemDescription,
      this.itemPrice,
      iImage,
      this.itemRating,
      this.rest_Id,
      this.quantity}) {
    if (iImage == null)
      this.iImage == "";
    else
      this.iImage = iImage;
    this.itemImage = Image.network(
        'http://appback.ppu.edu/static/${this.iImage}',
        fit: BoxFit.cover);
  }
  factory MenuItem.fromJson(dynamic jsonObject) {
    return MenuItem(
      menu_id: jsonObject['id'] as int,
      itemName: jsonObject['name'] as String,
      itemDescription: jsonObject['descr'] as String,
      itemPrice: jsonObject['price'] as int,
      iImage: jsonObject['image'] as String,
      itemRating: jsonObject['Rating'] as int,
      rest_Id: jsonObject['rest_id'] as int,
    );
  }
  factory MenuItem.fromMap(Map<String, dynamic> data) {
    return MenuItem(
      menu_id: data['id'] as int,
      itemName: data['name'] as String,
      itemDescription: data['descr'] as String,
      itemPrice: data['price'] as int,
      iImage: data['image'] as String,
      itemRating: data['Rating'] as int,
      rest_Id: data['rest_id'] as int,
    );
  }
  Map<String, dynamic> toJson() => {
        "id": menu_id,
        "rest_id": rest_Id,
        "name": itemName,
        "descr": itemDescription,
        "price": itemPrice,
        "image": iImage,
        "rating": itemRating,
      };
  Map<String, dynamic> toMap() {
    return {
      "id": this.menu_id,
      "rest_id": this.rest_Id,
      "name": this.itemName,
      "descr": this.itemDescription,
      "price": this.itemPrice,
      "image": this.iImage,
      "rating": this.itemRating,
    };
  }
}
