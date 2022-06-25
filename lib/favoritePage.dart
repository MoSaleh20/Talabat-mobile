import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:toast/toast.dart';
import 'databaseProvider.dart';
import 'globalDeclaration.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Favorite Items',
        ),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: FloatingActionButton.extended(
            heroTag: 'Clear',
            onPressed: () {
              DatabaseProvider.db.removeAll();
              Toast.show('Favorites cleared', context);
              setState(() {});
            },
            label: Text('Clear'),
            icon: Icon(Icons.clear),
            backgroundColor: Colors.amber,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: DatabaseProvider.db.favs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    favorite = snapshot.data;
                    if (favorite.isNotEmpty) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: favorite.length,
                        itemBuilder: (context, index) {
                          for (int i = 0; i < rests.length; i++) {
                            if (rests[i].restId == favorite[index].rest_Id) {
                              favorite[index].restName = rests[i].restName;
                            }
                          }
                          if (favorite.isEmpty)
                            return Text(
                              'Empty',
                              style: TextStyle(fontSize: 5000),
                            );
                          else
                            return Container(
                              height: 70,
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    _showDialog(context, index);
                                  },
                                  child: Container(
                                    child: favorite[index].itemImage,
                                    width: 100,
                                    height: 250,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              favorite[index].iImage),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          new BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 8.0)
                                        ],
                                        color: Colors.amber),
                                  ),
                                ),
                                title: Text('${favorite[index].itemName}'),
                                subtitle: Text('${favorite[index].restName}'),
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
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.0),
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
                      );
                    } else
                      return Center(
                        child: Text(
                          'No items',
                          style: TextStyle(fontSize: 50),
                        ),
                      );
                  } else
                    return Center(
                      child: Text(
                        'No items',
                        style: TextStyle(fontSize: 50),
                      ),
                    );
                })
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, int index) {
    showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text('${favorite[index].itemName}'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  child: favorite[index].itemImage,
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(favorite[index].iImage),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        new BoxShadow(color: Colors.black, blurRadius: 8.0)
                      ],
                      color: Colors.amber)),
              Text(
                "${favorite[index].itemPrice}₪",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.amber),
              ),
              SizedBox(
                height: 15,
              ),
            ]),
            actions: [
              Visibility(
                visible: !favorite[index].itemOrdered,
                child: IconButton(
                  onPressed: () {
                    _orderDialog(context, index);
                    setState(() {});
                  },
                  icon: Icon(Icons.shopping_cart_outlined),
                ),
              ),
              IconButton(
                onPressed: () {
                  DatabaseProvider.db.removeFav(favorite[index].menu_id);
                  Navigator.of(context).pop();
                  Toast.show('item removed', context);
                  setState(() {});
                },
                icon: Icon(Icons.delete_sweep),
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

  void AddToOrdered(index, quantity) {
    int count = int.parse(quantity);
    bool added = false;
    int id;
    for (int i = 0; i < ordered.length; i++)
      if (ordered[i].menu_id == favorite[index].menu_id) {
        added = true;
        id = i;
      }
    if (!added) {
      favorite[index].itemOrdered = true;
      ordered.add(favorite[index]);
      ordered[ordered.indexOf(favorite[index])].quantity = count;
    } else
      ordered[id].quantity = ordered[id].quantity + count;
    Toast.show('Item ordered', context);
  }
}
