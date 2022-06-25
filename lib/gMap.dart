import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import 'restaurant.dart';
import 'globalDeclaration.dart';
import 'loadingMenus.dart';

class GMap extends StatefulWidget {
  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  List<Restaurant> restaurants = rests;

  List<Marker> getMarkers(List<Restaurant> rests) {
    var markers = List<Marker>();
    for (int i = 0; i < rests.length; i++) {
      Marker marker = new Marker(
        markerId: MarkerId(rests[i].restName),
        draggable: false,
        infoWindow: InfoWindow(
          title: rests[i].restName,
          snippet: rests[i].restCity,
          onTap: () {
            _showDialog(this.context, restaurants[i]);
          },
        ),
        position:
            LatLng(double.parse(rests[i].lat)-i, double.parse(rests[i].lng)+i),
      );
      markers.add(marker);
    }
    return markers;
  }

  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    for (int i = 0; i < restaurants.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId("i"),
        position: LatLng(
            double.parse(restaurants[i].lat), double.parse(restaurants[i].lng)),
        infoWindow: InfoWindow(
          title: restaurants[i].restName,
          snippet: restaurants[i].restCity,
          onTap: () {
            _showDialog(this.context, restaurants[i]);
          },
        ),
      ));
    }
    setState(() {});
  }

  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(31.31541, 35.05328), zoom: 5);
  @override
  Widget build(BuildContext context) {
    var markers =
        (restaurants != null) ? this.getMarkers(restaurants) : List<Marker>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Find Restaurants nearby...',
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
      ),
    );
  }

  void _showDialog(BuildContext context,Restaurant rest) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('${rest.restName}'),
          content: Container(
            child: rest.restImage,
            width: 100,
            height: 250,
            decoration: BoxDecoration(
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
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingMenus(
                          rest.restId,
                          rest.restName),
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
