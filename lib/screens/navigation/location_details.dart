
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart';


class DetailsPage extends StatefulWidget {
  final String? placeId;
  final GooglePlace? googlePlace;
  final Function closePage;
  
  DetailsPage({Key? key, this.placeId, this.googlePlace, required this.closePage}) : super(key: key);

  @override
  _DetailsPageState createState() =>
      _DetailsPageState(this.placeId, this.googlePlace);
}

class _DetailsPageState extends State<DetailsPage> {
  final String? placeId;
  final GooglePlace? googlePlace;
  _DetailsPageState(this.placeId, this.googlePlace);

  DetailsResult? detailsResult;
  List<Uint8List> images = [];

  _closePage(){
    widget.closePage();
  }
  @override
  void initState() {
    getDetils(this.placeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:  UniqueKey(),
      direction: DismissDirection.down,
      onDismissed: (direction) async {_closePage();},
      child: Scaffold(
        appBar: AppBar(
          title: Text("Details"),
          backgroundColor: Colors.blueAccent,
//          actions: [
//            IconButton(onPressed: _closePage, icon: Icon(Icons.close))
//          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            getDetils(this.placeId);
          },
          child: Icon(Icons.refresh),
        ),
        body: SafeArea(
              child: Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 250,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.memory(
                                  images[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListView(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                "Details",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            detailsResult != null && detailsResult!.types != null
                                ? Container(
                                    margin: EdgeInsets.only(left: 15, top: 10),
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: detailsResult!.types!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Chip(
                                            label: Text(
                                              detailsResult!.types![index],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            backgroundColor: Colors.blueAccent,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.location_on),
                                ),
                                title: Text(
                                  detailsResult != null &&
                                          detailsResult!.formattedAddress != null
                                      ? 'Address: ${detailsResult!.formattedAddress}'
                                      : "Address: null",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.location_searching),
                                ),
                                title: Text(
                                  detailsResult != null &&
                                          detailsResult!.geometry != null &&
                                          detailsResult!.geometry!.location != null
                                      ? 'Geometry: ${detailsResult!.geometry!.location!.lat.toString()},${detailsResult!.geometry!.location!.lng.toString()}'
                                      : "Geometry: null",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.timelapse),
                                ),
                                title: Text(
                                  detailsResult != null &&
                                          detailsResult!.utcOffset != null
                                      ? 'UTC offset: ${detailsResult!.utcOffset.toString()} min'
                                      : "UTC offset: null",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.rate_review),
                                ),
                                title: Text(
                                  detailsResult != null &&
                                          detailsResult!.rating != null
                                      ? 'Rating: ${detailsResult!.rating.toString()}'
                                      : "Rating: null",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.attach_money),
                                ),
                                title: Text(
                                  detailsResult != null &&
                                          detailsResult!.priceLevel != null
                                      ? 'Price level: ${detailsResult!.priceLevel.toString()}'
                                      : "Price level: null",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Image.asset("assets/images/powered_by_google.png"),
                    ),
                  ],
                ),
              ),
            ),
      )
    );
    }

  void getDetils(String? placeId) async {
    var result = await this.googlePlace!.details.get(placeId as String);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result;
        images = [];
      });

     if (result.result!.photos != null) {
       for (var photo in result.result?.photos as List) {
         getPhoto(photo.photoReference);
       }
     }
    
    }
  }

  void getPhoto(String? photoReference) async {
   var result = await this.googlePlace!.photos.get(photoReference!, 0, 400);
   if (result != null && mounted) {
     setState(() {
       images.add(result);
     });
   }
  }
}
