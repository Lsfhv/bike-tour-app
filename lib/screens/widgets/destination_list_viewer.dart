import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../navigation/to_page.dart';

class DestinationListViewer extends StatefulWidget {
  const DestinationListViewer({ Key? key, required List<Destination> this.destinations,required this.onDismiss}) : super(key: key);
  final List<Destination> destinations;
  final Function onDismiss;
  @override
  State<DestinationListViewer> createState() => _DestinationListViewerState();
}


class _DestinationListViewerState extends State<DestinationListViewer> {

    
  _list_tile_dismiss(int index){
    widget.destinations.removeAt(index);
    widget.onDismiss(index);
  }
  @override
  Widget build(BuildContext context) {
    return Expanded( 
          child : ListView.builder(
            itemCount: widget.destinations.length,
            itemBuilder: (context, index) {
              return Dismissible(
                  key : UniqueKey(),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title:  Text(widget.destinations[index].name as String),
                    onTap: () { 
                    },
                  ),
                  direction: DismissDirection.horizontal,
                  //onDismissed: (direction) async {_list_tile_dismiss(index);},
                );
            },
          )
    );
    
  }
}