
import 'dart:typed_data';

import 'package:bike_tour_app/screens/navigation/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


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
  late DraggableScrollableController _controller;
  _DetailsPageState(this.placeId, this.googlePlace);

  DetailsResult? detailsResult;
  List<Uint8List> images = [];

  _closePage(){
    widget.closePage();
  }
  @override
  void initState() {
    getDetils(this.placeId);
    _controller = DraggableScrollableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Positioned(
      left:0,
      right: 0,
      bottom: 0,
      child : Dismissible(
        key:  UniqueKey(),
        direction: DismissDirection.down,
        onDismissed: (direction) async {_closePage();},
        child: _showPage(),
        
        )
      );

   
}
  
  _showPage(){
    return Container(
      constraints: BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(color : Colors.white, border: Border(top: BorderSide( width : 20, color : STANDARD_COLOR ))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          images.isNotEmpty ? Container(
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
            ) ,
          ) : CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            child: Image.asset("assets/images/powered_by_google.png"),
          ),
      ],
    ),
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
