import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'globalDeclaration.dart';
import 'package:toast/toast.dart';

class OrderedPage extends StatefulWidget {
  @override
  _OrderedPageState createState() => _OrderedPageState();
}

class _OrderedPageState extends State<OrderedPage> {
  @override
  Widget build(BuildContext context) {
    double price = 0;
    ordered.forEach((e) {
      price = price + (e.itemPrice * e.quantity);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Ordered Items',
        ),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: FloatingActionButton.extended(
            heroTag: 'Confirm',
            onPressed: () {
              _showConfirmDialog(context);
            },
            label: Text('Confirm'),
            icon: Icon(Icons.playlist_add_check),
            backgroundColor: Colors.amber,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Price = $price',
                style: TextStyle(fontSize: 30, letterSpacing: 0)),
            Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: ordered.length,
                  itemBuilder: (context, index) {
                    for (int i = 0; i < rests.length; i++) {
                      if (rests[i].restId == ordered[index].rest_Id) {
                        ordered[index].restName = rests[i].restName;
                      }
                    }
                    return Container(
                      height: 70,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            _showDialog(context, index);
                          },
                          // Open the resturant page.
                          child: Container(
                            child: ordered[index].itemImage,
                            width: 100,
                            height: 250,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(ordered[index].iImage),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.black, blurRadius: 8.0)
                                ],
                                color: Colors.amber),
                          ),
                        ),
                        title: Text('${ordered[index].itemName}'),
                        subtitle: Text(
                            '${ordered[index].restName} Price: ${ordered[index].itemPrice} Quantity: ${ordered[index].quantity}'),
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
                              ignoreGestures: true,
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
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, int index) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('${ordered[index].itemName}'),
          content: Container(
            child: ordered[index].itemImage,
            width: 100,
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ordered[index].iImage),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 8.0)
                ],
                color: Colors.amber),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                ordered.removeAt(index);
                setState(() {
                  Toast.show('Order deleted', context);
                });
              },
              icon: Icon(Icons.delete),
            ),
          ],
        );
      },
      context: context,
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Orders confimation'),
          actions: [
            Text('Delete All'),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                ordered.clear();
                setState(() {
                  Toast.show('Orders deleted', context);
                });
              },
              icon: Icon(Icons.delete_sweep),
            ),
            Text('Confirm All'),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                ordered.clear();
                setState(() {
                  Toast.show('Orders confirmed', context);
                });
              },
              icon: Icon(Icons.playlist_add_check),
            ),
          ],
        );
      },
      context: context,
    );
  }
}
