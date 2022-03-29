import 'package:flutter/material.dart';

class Destination_Retriever extends StatefulWidget {
  const Destination_Retriever(
      {Key? key, required this.onSubmitted, required this.onChanged})
      : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  @override
  _Destination_RetrieverState createState() => _Destination_RetrieverState();
}

class _Destination_RetrieverState extends State<Destination_Retriever> {
  late TextEditingController _controller;
  final String hintText = 'Where do you want to go?';
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit(String destination) {
    widget.onSubmitted!(destination);
    _controller.clear();
  }

  void _handleChange(String destination) {
    widget.onChanged!(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: Colors.white,
        ),
        controller: _controller,
        onSubmitted: (String destination) async {
          _handleSubmit(destination);
        },
        onChanged: (String destination) async {
          _handleChange(destination);
        },
      ))
    ]);
  }
}
