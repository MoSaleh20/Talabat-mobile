import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant_app/loadingOrders.dart';
import 'package:toast/toast.dart';
import 'databaseProvider.dart';
import 'menuItem.dart';
import 'globalDeclaration.dart';
import 'favoritePage.dart';

class RestaurantPage extends StatefulWidget {
  List<MenuItem> menu;
  String resName;
  @override
  _RestaurantPageState createState() =>
      _RestaurantPageState(this.menu, this.resName);
  RestaurantPage(this.menu, this.resName);
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<MenuItem> menu;
  String resName;

  _RestaurantPageState(this.menu, this.resName);

  @override
  void initState() {
    //  rest.restMenu = fetchMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (menu.isEmpty)
      return Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: FloatingActionButton(
                  heroTag: 'Favorite',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritePage(),
                        ));
                  },
                  child: Icon(Icons.favorite_border),
                  backgroundColor: Colors.amber,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: FloatingActionButton(
                  heroTag: 'Ordered',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingOrders(),
                        ));
                  },
                  child: Icon(Icons.shopping_cart_outlined),
                  backgroundColor: Colors.amber,
                ),
              )
            ],
          ),
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text(
              '${this.resName}',
            ),
          ),
          body: Center(
            child: Text(
              'No items',
              style: TextStyle(fontSize: 50),
            ),
          ));
    else
      return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: FloatingActionButton(
                heroTag: 'Favorite',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritePage(),
                      ));
                },
                child: Icon(Icons.favorite_border),
                backgroundColor: Colors.amber,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: FloatingActionButton(
                heroTag: 'Ordered',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadingOrders(),
                      ));
                },
                child: Icon(Icons.shopping_cart_outlined),
                backgroundColor: Colors.amber,
              ),
            )
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            '${this.resName}',
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: menu.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 70,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        _showDialog(context, index);
                      },
                      // Open the resturant page.
                      child: Container(
                        child: menu[index].itemImage,
                        width: 100,
                        height: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(menu[index].iImage),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.black, blurRadius: 8.0)
                            ],
                            color: Colors.amber),
                      ),
                    ),
                    title: Text('${menu[index].itemName}'),
                    subtitle: Container(
                        height: 30,
                        child: Text('${menu[index].itemDescription}')),
                    trailing: Column(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.bottomEnd,
                          height: 34,
                          width: 0,
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 22,
                          glowColor: Colors.black,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.black,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        )),
      );
  }

  void _showDialog(BuildContext context, int index) {
    showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text('${menu[index].itemName}'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  child: menu[index].itemImage,
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(menu[index].iImage),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        new BoxShadow(color: Colors.black, blurRadius: 8.0)
                      ],
                      color: Colors.amber)),
              Text(
                "${menu[index].itemPrice}₪",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.amber),
              ),
              SizedBox(
                height: 15,
              ),
              Text('${menu[index].itemDescription}'),
            ]),
            actions: [
              IconButton(
                onPressed: () {
                  //Navigator.of(context).pop();
                  //AddToOrdered(index);
                  _orderDialog(context, index);
                  // Open the resturant page.
                },
                icon: Icon(Icons.shopping_cart_outlined),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AddToFavorite(index);

                  // Open the resturant page.
                },
                icon: Icon(Icons.favorite_border),
              ),
            ],
          );
        },
        context: context);
  }

  void _orderDialog(BuildContext context, int index) {
    TextEditingController quantity = TextEditingController();
    quantity.text = "1";
    showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text('Quantity'),
            content: TextField(
                controller: quantity,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(icon: Icon(Icons.add_circle))),
            actions: [
              Visibility(
                  visible: quantity.text.isNotEmpty,
                  child: IconButton(
                    onPressed: () {
                      AddToOrdered(index, quantity.text);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.check),
                  ))
            ],
          );
        },
        context: context);
  }

  void AddToFavorite(index) {
    for (int i = 0; i < favorite.length; i++) {
      if (menu[index].menu_id == favorite[i].menu_id) return;
    }
    DatabaseProvider.db
        .insert(MenuItem(
            menu_id: menu[index].menu_id,
            itemName: menu[index].itemName,
            rest_Id: menu[index].rest_Id,
            itemRating: menu[index].restRating,
            iImage: menu[index].iImage,
            itemPrice: menu[index].itemPrice))
        .then((value) {
      print(value);
    });
    // DatabaseProvider.db.insert(menu[index]);
    menu[index].itemFavorite = true;
    favorite.add(menu[index]);
    Toast.show('Added to favorites', context);
    setState(() {});
    return;
  }

  void AddToOrdered(index, quantity) {
    int count = int.parse(quantity);
    bool added = false;
    int id;
    for (int i = 0; i < ordered.length; i++)
      if (ordered[i].menu_id == menu[index].menu_id) {
        added = true;
        id = i;
      }
    if (!added) {
      menu[index].itemOrdered = true;
      ordered.add(menu[index]);
      ordered[ordered.indexOf(menu[index])].quantity = count;
    }
    else
      ordered[id].quantity =
          ordered[id].quantity + count;
    Toast.show('Item ordered', context);
  }

  Icon FavIcon(index) {
    bool fav = false;
    for (int i = 0; i < ordered.length; i++) {
      if (menu[index].menu_id == ordered[i].menu_id) fav = true;
    }
    if (!fav)
      return Icon(Icons.favorite_border);
    else
      return Icon(Icons.favorite);
  }

  Icon OrderedIcon(index) {
    if (menu[index].itemOrdered == false)
      return Icon(Icons.shopping_cart_outlined);
    else
      return Icon(Icons.check);
  }
}
