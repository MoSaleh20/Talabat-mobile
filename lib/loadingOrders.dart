import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'menuItem.dart';
import 'orderItem.dart';
import 'orderdPage.dart';
import 'globalDeclaration.dart';

bool added = false;

class LoadingOrders extends StatefulWidget {
  @override
  _LoadingOrdersState createState() => _LoadingOrdersState();

  LoadingOrders();
}

class _LoadingOrdersState extends State<LoadingOrders> {
  void fetchOrder() async {
    List<OrderItem> orders;
    http.Response response1 = await http.get('http://appback.ppu.edu/order');
    if (response1.statusCode == 200) {
      var jsonArray = jsonDecode(response1.body) as List;
      orders = jsonArray.map((e) => OrderItem.fromJson(e)).toList();
      setState(() {});
    }
    if (!added)
      for (int i = 0; i < orders.length; i++) {
        for (int j = 0; j < mens.length; j++) {
          if (orders[i].menuId == mens[j].menu_id) {
            ordered.add(new MenuItem(
              menu_id: orders[i].menuId,
              rest_Id: orders[i].restId,
              iImage: mens[j].iImage,
              itemDescription: mens[j].itemDescription,
              itemName: mens[j].itemName,
              itemPrice: mens[j].itemPrice,
              quantity: orders[i].quantity,
            ));
            break;
          }
        }

        added = true;
      }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderedPage(),
        ));
    // else{
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RestaurantPage(null),));
    // }
  }

  @override
  void initState() {
    super.initState();
    fetchOrder();
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
            color: Colors.white,
            size: 50.0,
          ),
        ),
        Container(
            margin: EdgeInsets.all(50),
            child: Text('Loading Orders',
                style: TextStyle(fontSize: 15, letterSpacing: 10)))
      ]),
    );
  }
}
