import 'dart:async';
import 'dart:convert';
import 'package:car_buddy/loginscreen.dart';
import 'package:car_buddy/mainscreen.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
  super.initState();
  checkAndLogin();
  // Timer(
  // const Duration(seconds: 5),
  // () => Navigator.pushReplacement(context,
  // MaterialPageRoute(builder: (content) =>  const LoginScreen())));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash.png'),
                  fit: BoxFit.cover))),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                            "Version 1.0",
                            style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w100),
                            )
                            ],
                                ),
                            )
        ],
      ),
    );
  }

   checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(
            Uri.parse("${MyConfig().SERVER}/carBuddy/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
           
            if (jsondata['status'] == "success") {
              
              user = User.fromJson(jsondata['data']);
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            } else {
              user = User(
                  id: "na",
                  name: "na",
                  email: "na",
                  phone: "na",
                  datereg: "na",
                  password: "na",
                  otp: "na");
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(user: user))));
            }
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                phone: "na",
                datereg: "na",
                password: "na",
                otp: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException catch (_) {
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          datereg: "na",
          password: "na",
          otp: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}