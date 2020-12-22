import 'package:flutter/material.dart';
import 'package:gallery/screens/auth.dart';
import 'package:gallery/screens/pin_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool showPinCode = true;
  void toggleView(){
    setState(() => showPinCode = !showPinCode);
  }

  @override
  Widget build(BuildContext context) {

    if (showPinCode == true){
      return Pin(toggleView: toggleView);
    } else {
      return Auth(toggleView: toggleView);
    }
  }
}

