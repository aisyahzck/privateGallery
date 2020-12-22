import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallery/main.dart';
import 'package:gallery/pin_code/circle.dart';
import 'package:gallery/pin_code/keyboard.dart';
import 'package:gallery/pin_code/password.dart';

class Pin extends StatefulWidget {

  final Function toggleView;
  Pin({this.toggleView });


  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PIN Code'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.fingerprint),
              label: Text('Sign in via Biometric Scan'),
              onPressed: (){
                widget.toggleView();
              }
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _customColorsLockScreenButton(context)
            ],
          ),
        ),
      ),
    );
  }

  _showLockScreen(BuildContext context,
      {bool opaque,
        CircleUIConfig circleUIConfig,
        KeyboardUIConfig keyboardUIConfig,
        Widget cancelButton,
        List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
            title: Text(
              'Enter PIN Code',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 4,
            bottomWidget: _buildPasscodeRestoreButton(),
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: FlatButton(
        child: Text(
          "Reset passcode",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        splashColor: Colors.white.withOpacity(0.4),
        highlightColor: Colors.white.withOpacity(0.2),
        onPressed: _resetAppPassword,
      ),
    ),
  );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            FlatButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }


  _customColorsLockScreenButton(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialButton(
      color: Colors.deepPurpleAccent,
      child: Text(
          'Enter PIN Code',
          style: TextStyle(color: Colors.white)
      ),
      onPressed: () {
        _showLockScreen(context,
            opaque: false,
            circleUIConfig: CircleUIConfig(borderColor: Colors.white70, fillColor: Colors.white70, circleSize: 30),
            keyboardUIConfig: KeyboardUIConfig(digitBorderWidth: 2, primaryColor: Colors.white70),
            cancelButton: Icon(
              Icons.arrow_back,
              color: Colors.deepPurpleAccent,
            ),
            digits: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']);
      },
    );
  }
}