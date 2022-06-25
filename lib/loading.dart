import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/restaurant.dart';
import 'globalDeclaration.dart';
import 'mainPage.dart';
import 'menuItem.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<Restaurant> restaurants = [];
  void fetchRestaurants() async {
    http.Response response =
        await http.get('http://appback.ppu.edu/restaurants');
    if (response.statusCode == 200) {
      var jsonArray = jsonDecode(response.body) as List;
      restaurants = jsonArray.map((e) => Restaurant.fromJson(e)).toList();
      setState(() {});
    }
    rests = restaurants;
    fetchMenu();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ));
  }

  void fetchMenu() async {
    for (int i = 0; i < rests.length; i++) {
      List<MenuItem> menus;
      http.Response response1 =
          await http.get('http://appback.ppu.edu/menus/${rests[i].restId}');
      if (response1.statusCode == 200) {
        var jsonArray = jsonDecode(response1.body) as List;
        menus = jsonArray.map((e) => MenuItem.fromJson(e)).toList();
      }
      if (menus.isNotEmpty) mens.addAll(menus);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF3C00),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: EdgeInsets.all(50),
            child: Text('TALABAT',
                style: TextStyle(fontSize: 30, letterSpacing: 10))),
        Center(
          child: SpinKitPouringHourglass(
            color: Colors.black,
            size: 50.0,
          ),
        )
      ]),
    );
  }
}
