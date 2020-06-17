import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  void authValidation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authId = prefs.getString('authId');
    if(authId != null){
      print(authId);
      Navigator.pushReplacementNamed(context, '/home');
    }else{
      print("Not found");
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    authValidation();
    return Scaffold(
      body: Container(
        child: Center(child: SpinKitRing(color: Colors.greenAccent, size: 40, lineWidth: 3,)),
      ) 
    );
  }
}