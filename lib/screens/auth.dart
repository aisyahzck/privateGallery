import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:gallery/photo_album/home.dart';
import 'package:local_auth/auth_strings.dart';

class Auth extends StatefulWidget {

  final Function toggleView;
  Auth({this.toggleView });

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  LocalAuthentication _auth = LocalAuthentication();
  bool _checkBio = false;
  bool _isBioFinger = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _listBioAndFindFingerType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Biometric Scan'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.assignment_ind),
              label: Text('Sign in via PIN Code'),
              onPressed: () {
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
                  IconButton(icon: Icon(Icons.fingerprint, size: 70, color: Colors.deepPurpleAccent,), onPressed: () {
                    _startAuth();
                  }, iconSize: 70,),
                  SizedBox(height: 20),
                  Text(
                    'Scan your fingerprint to enter',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                ],
              ),
            ),
          ),
      );
  }

  void _checkBiometrics() async {
    try {
      final bio = await _auth.canCheckBiometrics;
      setState(() {
        _checkBio = bio;
        print('Biometrics = $_checkBio');
      });
    } catch (e) {}
  }

  void _listBioAndFindFingerType() async {
    List<BiometricType> _listType;
    try{
      _listType = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e.message);
    }
    print('List Biometrics = $_listType');

    if (_listType.contains(BiometricType.fingerprint)) {
      setState(() {
        _isBioFinger = true;
      });
    }
    print('Fingerprint is $_isBioFinger');
  }

  void _startAuth() async {
    bool _isAuthenticated = false;
     AndroidAuthMessages _msg = AndroidAuthMessages(
       signInTitle: 'Sign In To Enter',
       cancelButton: 'Cancel',
     );

    try {
      _isAuthenticated = await  _auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint',
        useErrorDialogs: true,
        stickyAuth: true,  // native process
        androidAuthStrings: _msg,
      );
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (_isAuthenticated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => HomePage()));

    }
  }
}
