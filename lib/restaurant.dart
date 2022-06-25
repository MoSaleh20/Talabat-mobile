import 'package:flutter/material.dart';

class Restaurant {
  int restId;
  String restName;
  String restCity;
  int restRating;
  String rImage;
  Image restImage;
  String lat;
  String lng;

  Restaurant(
      {this.restId,
      this.restName,
      this.restCity,
      this.lat,
      this.lng,
      this.restRating,
      rImage}) {
    if (rImage == null)
      this.rImage = "";
    else
      this.rImage = rImage;
    this.restImage = Image.network(
        'http://appback.ppu.edu/static/${this.rImage}',
        fit: BoxFit.cover);
  }
  factory Restaurant.fromJson(dynamic jsonObject) {
    return Restaurant(
        restId: jsonObject['id'] as int,
        restName: jsonObject['name'] as String,
        lat: jsonObject["lat"],
        lng: jsonObject["lng"],
        restCity: jsonObject['city'] as String,
        restRating: jsonObject['rating'] as int,
        rImage: jsonObject['image'] as String);
  }

  Map<String, dynamic> toJson() => {
        "id": restId,
        "name": restName,
        "city": restCity,
        "lat": lat,
        "lng": lng,
        "image": rImage,
        "rating": restRating,
      };
}
