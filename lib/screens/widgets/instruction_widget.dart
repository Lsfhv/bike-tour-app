import 'package:bike_tour_app/models/instruction_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import '../navigation/constants.dart';
import 'compass.dart';


class InstructionWidget extends StatefulWidget {
  const InstructionWidget({ Key? key, required this.instruction}) : super(key: key);
  final Instruction instruction;
  @override
  State<InstructionWidget> createState() => _InstructionWidgetState();
}

class _InstructionWidgetState extends State<InstructionWidget> {
  late LatLng destination;
  late String direction;
  // ignore: non_constant_identifier_names
  final TEXT_STYLE = {'b' :Style(fontSize: const FontSize(20),fontWeight: FontWeight.normal),'' : Style(fontSize: const FontSize(20),fontWeight: FontWeight.bold)};
  //GoogleFonts.lato(color: Colors.white, fontSize: 15);
  _init(){
    destination = widget.instruction.end_loc;
    direction = "<b>" + widget.instruction.instruction + "</b>";
  }



  @override
  Widget build(BuildContext context) {
    _init();
    return Row( 
      children: [
        Expanded(child: 
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          color: STANDARD_COLOR,
          padding: EdgeInsets.all(10),
          child:  Html(data : direction, style : TEXT_STYLE),
        ),
        ),
        // Container( //error here
        //   width : MediaQuery.of(context).size.width * 1/10,
        //   child : Compass(),
        // )
      ],
    );
  }
}