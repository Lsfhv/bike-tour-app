//courtesy of https://github.com/kdemanuele/Flutter-Loading-Screen/blob/master/lib/widget/loading_screen.dart
// ignore_for_file: unnecessary_new

import 'package:bike_tour_app/screens/widgets/destination_list_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../models/destination_model.dart';

/// Loading Screen Widget that updates the screen once all inistializer methods
/// are called
class LoadingScreen extends StatefulWidget {
  /// List of methods that are called once the Loading Screen is rendered
  /// for the first time. These are the methods that can update the messages
  /// that are shown under the loading symbol
  //final List<dynamic> initializers;

  /// The name of the application that is shown at the top of the loading screen
  final RichText title;

  /// The background colour which is used as a filler when the image doesn't
  /// occupy the full screen
  final Color backgroundColor;

  /// The styling that is used with the text (messages) that are displayed under
  /// the loader symbol
  final TextStyle styleTextUnderTheLoader;

  /// The Layout/Scaffold Widget that is loaded once all the initializer methods
  /// have been executed
  //final dynamic navigateToWidget;

  /// The colour that is used for the loader symbol
  final Color loaderColor;

  /// The image widget that is used as a background cover to the loading screen
  final Image image;

  /// The message that is displayed on the first load of the widget
  final String initialMessage;
  static RichText DEFAULT_TITLE = RichText(text: const TextSpan(text: 'Welcome In Our App'));
  final List<Destination> destinations;
  /// Constructor for the LoadingScreen widget with all the required
  /// initializers
  LoadingScreen(
      {//required this.initializers,
      //this.navigateToWidget,
      required this.loaderColor,
      required this.image,
      required this.title,
      this.backgroundColor = Colors.white,
      this.styleTextUnderTheLoader = const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      required this.initialMessage,
      required this.destinations});
      // The Widget depends on the initializers and navigateToWidget to have a
      // valid value. Thus we assert that the values passed are valid and
      // not null
      //: //assert(initializers != null && initializers.length > 0),
        //assert(navigateToWidget != null);

  /// Bind t`he Widget to the custom State object
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}


/// The custom state that is used by the Loading Screen widget to handle the
/// messages that are provided by the initializer methods.
///
/// Note: Although the class is not exported from the package as not required by
/// the implementers using the package, the protected metatag is added to make
/// the code clearer.
@protected
class _LoadingScreenState extends MessageState<LoadingScreen> {

  /// Initialise the state
  @override
  void initState() {
    super.initState();

    /// If the LoadingScreen widget has an initial message set, then the default
    /// message in the MessageState class needs to be updated
    if (widget.initialMessage != null) {
      initialMessage = widget.initialMessage;
    }
    
    /// We require the initializers to run after the loading screen is rendered
    // SchedulerBinding.instance?.addPostFrameCallback((_) {
    //   runInitTasks();
    // });
  }

  /// This method calls the initializers and once they complete redirects to
  /// the widget provided in navigateAfterInit
  // @protected
  // Future runInitTasks() async {
  //   /// Run each initializer method sequentially
  //   Future.forEach(widget.initializers, (init) => init!).whenComplete(() {
  //     // When all the initializers has been called and terminated their
  //     // execution. The screen is navigated to the next scaffolding widget
  //     if (widget.navigateToWidget is String) {
  //       // It's fairly safe to assume this is using the in-built material
  //       // named route component
  //       Navigator.of(context).pushReplacementNamed(widget.navigateToWidget);
  //     } else if (widget.navigateToWidget is Widget) {
  //       Navigator.of(context).pushReplacement(new MaterialPageRoute(
  //           builder: (BuildContext context) => widget.navigateToWidget));
  //     } else {
  //       throw new ArgumentError(
  //           'widget.navigateAfterSeconds must either be a String or Widget');
  //     }
  //   });
  // }

  /// Render the LoadingScreen widget
  @override
  Widget build(BuildContext context) {
    final destinations = widget.destinations;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body:  InkWell(
        child:  Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /// Paint the area where the inner widgets are loaded with the
            /// background to keep consistency with the screen background
            Container(
              decoration: BoxDecoration(color: widget.backgroundColor),
            ),
            /// Render the background image
            // Container(child: widget.image),
        
  
            /// Render the Title widget, loader and messages below each other
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              //     Expanded(
              //       flex: 3,
              //       child: Container(
              //           child:  Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: <Widget>[
              //               // ignore: prefer_const_constructors
              //               Padding(
              //                 padding: const EdgeInsets.only(top: 30.0),
              //               ),
              //               widget.title,
              //             ],
              //           )),
              //     ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SafeArea(
                          child: Container(
                            child: DestinationViewerLoadingScreen(destinations : destinations),
                            height: MediaQuery.of(context).size.height * 8/13,
                            )),
                        /// Loader Animation Widget
                        // CircularProgressIndicator(
                        //   valueColor: new AlwaysStoppedAnimation<Color>(
                        //       widget.loaderColor),
                        // ),
                        Container(child: widget.image),//width: MediaQuery. of(context). size. width/3 ,), 
                        // Padding(
                        //   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 1/13),
                        // ),
                        Text(getMessage, style: widget.styleTextUnderTheLoader),
                      ],
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// An extension class to the Flutter standard State. The class provides getter
/// and setters for updating the message section of the loading screen
///
/// Note: The class is marked as abstract to avoid IDE issues that expects
/// protected methods to be overloaded
abstract class MessageState<T extends StatefulWidget> extends State<T> {
  /// The state variable that will hold the latest message that needs to be
  /// displayed.
  ///
  /// Note: Although Flutter standard allow member variables to be used from
  /// instance object reference, this is not a best practice with OOP. OOP
  /// design proposes that member variables should be accessed through getter
  /// and setter methods.
  @protected
  String _message = 'Loading . . .';

  /// The member variable is set as protected this it is not exposed to the
  /// widget state class. As a workaround a protected setter is set so it is
  /// not used outside the package
  @protected
  set initialMessage(String message) => _message = message;

  /// Setter for the message variable
  set setMessage(String message) => setState(() {
        _message = message;
      });

  /// Getter for the message variable
  String get getMessage => _message;
}