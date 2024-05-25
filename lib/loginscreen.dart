import 'dart:convert';

import 'package:car_buddy/mainscreen.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:car_buddy/registrationscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  bool _isChecked = false;

  @override
  void initState(){
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
     screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
        children: [
          const SizedBox(height: 20,),
          Text(
            "C A R B U D D Y",
            style: GoogleFonts.titanOne(
              fontSize: 35,
              color: const Color.fromRGBO(249, 148, 23, 1),
            ),
          ),
          const SizedBox(height: 10), // Add some space between the texts
          Text(
            "Your Ride's New Best Friend",
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10), // Add some space between the texts
          SizedBox(
              height: screenHeight * 0.35,
              width: screenWidth,
             child: Image.asset("assets/images/logo.png",
             fit: BoxFit.contain,),
            ),
          const SizedBox(height: 10), // Add some space between the texts
          Text(
            "Welcome Back!",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15,),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailEditingController,
                validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                  ? "Please enter a valid email"
                  : null,
                 keyboardType: TextInputType.emailAddress,
                 decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter your email',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(217, 217, 217, 1)
                 ),
                 prefixIcon: Icon(Icons.email),
                 enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                 ),
                 focusedBorder: OutlineInputBorder(
                 borderSide: BorderSide.none,
                 borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                    )
                      ),
                      const SizedBox(height: 10,),
                  TextFormField(
                    controller: _passEditingController,
                    validator: (val) => val!.isEmpty || (val.length < 5)
                      ? "Password must be longer than 5"
                      : null,
                    obscureText: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Enter your password',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(217, 217, 217, 1)
                    ),
                    prefixIcon: Icon(Icons.key),
                     enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                 ),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                     floatingLabelBehavior: FloatingLabelBehavior.never,
                              )
                        ),
                  const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isChecked, 
                              onChanged: (bool? value){
                                saveremovepref(value!);
                                setState(() {
                                  _isChecked = value;
                                });
                              },
                              // checkColor: Colors.white, // Set the color of the check mark
                              // activeColor: Colors.white, // Set the color of the checkbox itself
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: null,
                                  child: const Text("Remember Me",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),),
                                )),
                                const SizedBox(
                                  width: 10,
                                  ),
                          ],
                        ),
                        MaterialButton(
                                    color: const Color.fromRGBO(249, 148, 23, 1),
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                    minWidth: 100,
                                    height: 35,
                                    elevation: 10,
                                    onPressed: onLogin,
                                    child:  Text("Login",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white
                                    ),)
                                    ),
                        const SizedBox(
                          height: 8,
                          ),
                          GestureDetector(
                            onTap: _goToRegister,
                            child: Text("New user? Register",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                            ),)
                          ),
                          const SizedBox(
                          height: 8,
                          ),
                          // GestureDetector(
                          //   onTap: _forgotDialog,
                          //   child: Text("Forgot Password?",
                          //   style: GoogleFonts.poppins(
                          //     fontSize: 12,
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.w400
                          //   ),)
                          // ),
            ],
          ))
        ],
          ),
        ),
      ),
      
      ),
    );
  }

  void onLogin() {
  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Check your input")),
    );
    return;
  }

  String email = _emailEditingController.text;
  String pass = _passEditingController.text;

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/login_user.php"),
      body: {
        "email": email,
        "password": pass,
      }).then((response) {
    print(response.body);
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        User user = User.fromJson(jsondata['data']);
        print(user.name);
        print(user.email);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Success")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(user: user,)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed")),
      );
    }
  });
}


  void _goToRegister() {
     Navigator.push(context, MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  // void _forgotDialog() {
  // }

  void saveremovepref(bool value) async{
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value){
      if(!_formKey.currentState!.validate()){
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('checkbox', value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    }else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  } 

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email'))??'';
    String password = (prefs.getString('pass'))??'';
    _isChecked = (prefs.getBool('checkbox'))?? false;
    if(_isChecked){
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
      });
    }
  }
}