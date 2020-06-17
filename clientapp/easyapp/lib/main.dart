import 'dart:convert';

import 'package:easyapp/pages/loginPage.dart';
import 'package:easyapp/pages/registerPage.dart';
import 'package:easyapp/pages/splashPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashPage(),
        '/register' : (context) => RegisterPage(),
        '/login' : (context) => LoginPage(),
        '/home' : (context) => Home(),
      },
    )
  );
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _nameTagSearchController = new TextEditingController();
  String url = "https://infinite-sands-58254.herokuapp.com/api/user/find";
  Map searchData = {};

  void logoutUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authId');
    Navigator.pushReplacementNamed(context, '/');
  }

  void findUserByTagName() async{
    // var uri = Uri.http(url, '', {"nameTag" : _nameTagSearchController.text});
    var userData = await http.get('$url?nameTag=${_nameTagSearchController.text}');
    print(userData.body);
    
    if(json.decode(userData.body)['_id'] != null){
      setState(() {
        searchData = json.decode(userData.body);
      });
    }else{
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Easy Call'),),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xffefefef),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _nameTagSearchController,
                      decoration: InputDecoration(
                        hintText: 'Search by Tag Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10)
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.greenAccent,
                    onTap: (){
                      findUserByTagName();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      child: Icon(Icons.search),
                    ),
                  )
                ],
              ),
            ),
            (searchData.isNotEmpty) ? 
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffefefef),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tag Name :  ',
                          style: TextStyle(color: Colors.black, fontSize: 20)
                        ),
                        TextSpan(
                          text: searchData['nameTag'],
                          style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)
                        ),
                      ]
                    )
                  ),
                  RichText(
                    
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Phone Number :  ',
                          style: TextStyle(color: Colors.black, fontSize: 20)
                        ),
                        TextSpan(
                          text: '${searchData['phone']}',
                          style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
                        ),
                      ]
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          launch("tel://${searchData['phone']}");
                        },
                        splashColor: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(Icons.call),
                              ),
                              Text('Call', style: TextStyle(fontWeight : FontWeight.bold),)
                            ],
                          )
                        ),
                      ),
                    ),
                  )
                ]
              ),
            ) : Container(),
            // FlatButton(
            //   onPressed: (){
            //     logoutUser();
            //   },
            //   child: Text('Log Out'),
            // )
          ]
        ),
      ),
    );
  }
}