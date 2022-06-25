import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/restaurantPage.dart';
import 'menuItem.dart';

List<MenuItem> mns = [];

class LoadingMenus extends StatefulWidget {
  final int restId;
  String resName;
  @override
  _LoadingMenusState createState() => _LoadingMenusState(restId, resName);

  LoadingMenus(this.restId, this.resName);
}

class _LoadingMenusState extends State<LoadingMenus> {
  int restId;
  String resName;
  List<MenuItem> mns1;
  _LoadingMenusState(this.restId, this.resName);

  void fetchMenu() async {
    List<MenuItem> menus;
    http.Response response1 =
        await http.get('http://appback.ppu.edu/menus/$restId');
    if (response1.statusCode == 200) {
      var jsonArray = jsonDecode(response1.body) as List;
      menus = jsonArray.map((e) => MenuItem.fromJson(e)).toList();
      setState(() {});
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantPage(menus, resName),
        ));
  }

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
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
        ),
        Container(
            margin: EdgeInsets.all(50),
            child: Text('Loading Menus',
                style: TextStyle(fontSize: 15, letterSpacing: 10)))
      ]),
    );
  }
}
