import 'package:flutter/material.dart';

class TutorialWrapper extends StatefulWidget {
  const TutorialWrapper({ Key? key,required this.child, required this.tutorialText }) : super(key: key);
  final Widget child;
  final String tutorialText;
  @override
  State<TutorialWrapper> createState() => _TutorialWrapperState();
}

class _TutorialWrapperState extends State<TutorialWrapper> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      widget.child,
      SimpleDialog(title: Text(widget.tutorialText),
        children: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("ok!")),
        ],
      ),
    ],
    );
  }
}