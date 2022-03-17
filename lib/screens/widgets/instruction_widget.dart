import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../navigation/dynamic_navigation.dart';


class InstructionWidget extends StatefulWidget {
  const InstructionWidget({ Key? key, required this.instruction}) : super(key: key);
  final Instruction instruction;
  @override
  State<InstructionWidget> createState() => _InstructionWidgetState();
}

class _InstructionWidgetState extends State<InstructionWidget> {
  late LatLng destination;
  late String direction;
  
  _init(){
    destination = widget.instruction.end_loc;
    direction = widget.instruction.instruction;
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return ExpandablePanel(
      header: Text("Latest Directions"),
      collapsed: Text(direction, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
      expanded: Text(direction, softWrap: true, ),
    );
  }
}