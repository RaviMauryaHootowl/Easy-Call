import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _nameTagController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String url = "https://infinite-sands-58254.herokuapp.com/api/user/register";

  void saveToPref(String authId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authId', authId);
    print("$authId saved!");
  }

  void getFromPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authId = prefs.getString('authId');
    if(authId != null){
      print('You are registered $authId');
    }
  }

  void registerUser() async{
    var body = jsonEncode({"phone" : _phoneController.text, "nameTag" : _nameTagController.text, "password" : _passwordController.text});
    var res = await http.post(url,headers: {"Content-Type": "application/json"}, body: body);
    print(res.body);
    if(json.decode(res.body)['_id'] != null){
      print(json.decode(res.body)['_id']);
      saveToPref(json.decode(res.body)['_id']);
      Navigator.pushReplacementNamed(context, '/');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    getFromPref();
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
                        Center(child: Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),)),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xffefefef),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: 'Your Phone Number',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10)
                            ),
                            keyboardType: TextInputType.number,
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
                            controller: _nameTagController,
                            decoration: InputDecoration(
                              hintText: 'Choose a Tag Name',
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
                              hintText: 'Set a new Password',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 8),
              child: InkWell(
                splashColor: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Container(
                  height: 60,
                  child: Center(child: Text('Already Registered? Login', style: TextStyle(fontSize: 18),))
                ),
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
                  splashColor: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                  onTap: (){
                    registerUser();
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: Center(child: Text('Register', style: TextStyle(fontSize: 20, color: Colors.white),))
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