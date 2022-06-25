import 'package:flutter/material.dart';
import 'package:restaurant_app/loadingOrders.dart';
import 'package:toast/toast.dart';
import 'gMap.dart';
import 'restaurant.dart';
import 'globalDeclaration.dart';
import 'favoritePage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'loadingMenus.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String cityFilter = "City"; // for filtering by city
  String ratingFilter = 'Rating'; // for filtering by rating
  List<Restaurant> restaurants = rests;
  bool cityChecked = true;

  @override
  void initState() {
    super.initState();
    // fetchMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black, size: 50),
        centerTitle: true,
        bottomOpacity: 500,
        shadowColor: Colors.black,
        toolbarHeight: 80,
        elevation: 20,
        backgroundColor: Color(0xFFFF3C00),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.0,
              child: Image.network(
                "https://www.celebrateoman.com/wp-content/uploads/elementor/thumbs/Talabat-Logo@3x-op0bqem61rczrwa5fzse8all7yb8btlp43uh9pbwp4.png",
                fit: BoxFit.fitWidth,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            // floating button for favorite page.//
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
              backgroundColor: Color(0xFFFF3C00),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),

            // floating button for ordered page.//
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
              backgroundColor: Color(0xFFFF3C00),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: 100,
            width: 100,
            // floating button for favorite page.//
            child: FloatingActionButton(
              heroTag: 'Map',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GMap(),
                    ));
              },
              child: Icon(Icons.map),
              backgroundColor: Color(0xFFFF3C00),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // row for filtering options.//
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  // filter by city.//
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                    child: DropdownButton<String>(
                      value: cityFilter,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: citySortColor()),
                      underline: Container(
                        height: 2,
                        color: citySortColor(),
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          cityFilter = newValue;
                          setCity();
                        });
                      },
                      items: <String>[
                        'City',
                        'Hebron',
                        'Ramallah',
                        'Beit Jala',
                        'BeitLahem'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              // filter by rating.//
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                    child: DropdownButton<String>(
                      value: ratingFilter,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: ratingSortColor()),
                      underline: Container(
                        height: 2,
                        color: ratingSortColor(),
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          ratingFilter = newValue;
                          setRating();
                        });
                      },
                      items: <String>[
                        'Rating',
                        '1 Star',
                        '2 Stars',
                        '3 Stars',
                        '4 Stars',
                        '5 Stars',
                        '6 Stars',
                        '7 Stars',
                        '8 Stars',
                        '9 Stars',
                        '10 Stars'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            ]),
            Container(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      if (restaurants.isEmpty)
                        return Text(
                          'Empty',
                          style: TextStyle(fontSize: 100),
                        );
                      else
                        return Container(
                          height: 70,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            //gesturing the image of the restaurant.//
                            leading: GestureDetector(
                              onTap: () {
                                _showDialog(this.context, index);
                              },
                              //image rendering container .//
                              child: Container(
                                //image from the network used for demonstration.
                                child: restaurants[index].restImage,
                                width: 100,
                                height: 250,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage(restaurants[index].rImage),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      new BoxShadow(
                                          color: Colors.black, blurRadius: 8.0)
                                    ],
                                    color: Color(0xFFFF3C00)),
                              ),
                            ),
                            title: Text('${restaurants[index].restName}'),
                            //title of restaurant
                            subtitle: Text('${restaurants[index].restCity}'),
                            //city of restaurant
                            //Rating and Visiting.//
                            trailing: Column(
                              children: [
                                //icon button for visiting restaurant menu.//
                                Container(
                                    //alignment: AlignmentDirectional.bottomEnd,
                                    height: 34,
                                    // width: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoadingMenus(
                                                      restaurants[index].restId,
                                                      restaurants[index]
                                                          .restName),
                                            ));
                                        // Open the resturant page.
                                      },
                                      icon: Icon(Icons.arrow_forward_outlined),
                                    )),
                                // show rate of restaurant......can't be edited.//
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      '${this.restaurants[index].restRating}'),
                                  minRating: 0,
                                  maxRating: 10,
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
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                  ),
                  Container(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color ratingSortColor() {
    if (cityChecked)
      return Colors.black;
    else
      return Colors.deepPurple;
  }

  Color citySortColor() {
    if (!cityChecked)
      return Colors.black;
    else
      return Colors.deepPurple;
  }

  void setRating() {
    cityChecked = false;
    int rating;
    if (ratingFilter == "1 Star") {
      rating = 1;
    } else if (ratingFilter == "2 Stars") {
      rating = 2;
    } else if (ratingFilter == "3 Stars") {
      rating = 3;
    } else if (ratingFilter == "4 Stars") {
      rating = 4;
    } else if (ratingFilter == "5 Stars") {
      rating = 5;
    } else if (ratingFilter == "6 Stars") {
      rating = 6;
    } else if (ratingFilter == "7 Stars") {
      rating = 7;
    } else if (ratingFilter == "8 Stars") {
      rating = 8;
    } else if (ratingFilter == "9 Stars") {
      rating = 9;
    } else if (ratingFilter == "10 Stars") {
      rating = 10;
    }
    if (ratingFilter == "Rating") {
      this.restaurants = rests;
    } else {
      this.restaurants = [];
      for (int i = 0; i < rests.length; i++) {
        if (rests[i].restRating == rating) this.restaurants.add(rests[i]);
      }
    }
  }

  void setCity() {
    cityChecked = true;
    if (cityFilter == "City") {
      this.restaurants = rests;
    } else {
      this.restaurants = [];
      for (int i = 0; i < rests.length; i++) {
        if (rests[i].restCity == this.cityFilter)
          this.restaurants.add(rests[i]);
      }
    }
  }

  void _showDialog(BuildContext context, int index) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('${restaurants[index].restName}'),
          content: Container(
            child: restaurants[index].restImage,
            width: 100,
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(restaurants[index].rImage),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 50.0)
                ],
                color: Color(0xFFFF3C00)),
          ),
          actions: [
            Text(
              'Rate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RatingBar.builder(
              minRating: 1,
              itemPadding: EdgeInsets.all(0),
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 22,
              glowColor: Colors.black,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.black,
              ),
              onRatingUpdate: (rating) {
                Toast.show('Rating saved', context);
                print(rating);
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingMenus(
                          restaurants[index].restId,
                          restaurants[index].restName),
                    ));
              },
              icon: Icon(Icons.arrow_forward_outlined),
            ),
          ],
        );
      },
      context: context,
    );
  }
}
