import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameTagController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String url = "https://infinite-sands-58254.herokuapp.com/api/user/login";

  void saveToPref(String authId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authId', authId);
    //print("$authId saved!");
  }

  void registerUser() async{
    var body = jsonEncode({"nameTag" : _nameTagController.text, "password" : _passwordController.text});
    var res = await http.post(url,headers: {"Content-Type": "application/json"}, body: body);
    print(res.body);
    if(json.decode(res.body)['user']['_id'] != null){
      saveToPref(json.decode(res.body)['user']['_id']);
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0xff2ecc71),
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top:20),
                child: Center(child: Text('Easy Call', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),)),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children : [
                        Center(child: Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),)),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: _nameTagController,
                            decoration: InputDecoration(
                              hintText: 'Enter your Tag Name',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10)
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: 'Enter your Password',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                            obscureText: true,
                          ),
                        ),
                        
                      ]
                    ),
                  ),
                )
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff2ecc71),
                borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: (){
                    registerUser();
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: Center(child: Text('Log In', style: TextStyle(fontSize: 20, color: Colors.white),))
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}