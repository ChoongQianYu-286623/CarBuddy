import 'dart:convert';
import 'package:car_buddy/loginscreen.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
 final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _icEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth;



 @override
  Widget build(BuildContext context) {
     screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Text("SIGN UP",
                 style: GoogleFonts.titanOne(
                  fontSize: 45,
                  color: const Color.fromRGBO(249, 148, 23, 1),
                ),),
                const SizedBox(height: 10), // Add some space between the texts
              Text(
                "Start your ride with us",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
               const SizedBox(height: 50),
               Padding(padding: const EdgeInsets.all(8.0),
               child: Card(
                 color: const Color.fromRGBO(217, 217, 217, 90),
                 shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))
                 ),
                 elevation: 8,
                 child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Name",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white
                              ),),
                            ),
                            TextFormField(
                  controller: _nameEditingController,
                  validator: (val) => val!.isEmpty || (val.length < 5)
                  ? "Name must be longer than 5"
                  : null,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    filled: true,
                  fillColor: Colors.white,
                    labelText: "",
                    labelStyle: TextStyle(
                    ),
                    // icon: Icon(Icons.person),
                    enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                    ),
                    borderSide: BorderSide.none
                 ),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                 const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("I/C Number",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white
                              ),),
                            ),
                TextFormField(
                  controller: _icEditingController,
                  validator: (val) => val!.isEmpty || val.length != 12 || val.contains("-")
                  ? "Please enter a valiid I/C number without - in between"
                  : null,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "",
                    labelStyle: TextStyle(),
                    enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                    ),
                    borderSide: BorderSide.none
                 ),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Email",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white
                              ),),
                            ),
                TextFormField(
                  controller: _emailEditingController,
                  validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                  ? "Please enter a valid email"
                  : null,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "",
                    labelStyle: TextStyle(),
                    // icon: Icon(Icons.email_outlined),
                    enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                    ),
                    borderSide: BorderSide.none
                 ),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Contact Number",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white
                              ),),
                            ),
                TextFormField(
                  controller: _phoneEditingController,
                  validator: (val) => val!.isEmpty || (val.length < 10)
                  ? "phone must be longer than 10"
                  : null,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    filled: true,
                  fillColor: Colors.white,
                    labelText: "",
                    labelStyle: TextStyle(),
                    // icon: Icon(Icons.phone_android),
                    enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                    ),
                    borderSide: BorderSide.none
                 ),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Password",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white
                              ),),
                            ),
                TextFormField(
                  controller: _passEditingController,
                  validator: (val) => val!.isEmpty || (val.length < 5)
                  ? "Password must be longer than 5"
                  : null,
                  obscureText: _isObscure,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                  fillColor: Colors.white,
                    labelText: "",
                    labelStyle: const TextStyle(),
                    // icon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: (){
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },),
                    enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                    ),
                    borderSide: BorderSide.none
                 ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Re-enter Password",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white
                              ),),
                            ),
                TextFormField(
                  controller: _pass2EditingController,
                  validator: (val) => val!.isEmpty || (val.length < 5)
                  ? "Password must be longer than 5"
                  : null,
                  obscureText: _isObscure,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                  fillColor: Colors.white,
                    labelText: "",
                    labelStyle: const TextStyle(),
                    // icon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: (){
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },),
                   enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                    ),
                    borderSide: BorderSide.none
                 ),
                    focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                          ],
                        )
                        )
                    ],
                  ),
                 ),
               
               ),),
              const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: onRegisterDialog, 
                   style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(249, 148, 23, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )
                    ),
                  child: Text("Register",
                  style: GoogleFonts.poppins(
                    color: Colors.white
                  ),))
              ],
            ),
          ),
        ),
      )
    );
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    String passa = _passEditingController.text;
    String passb = _pass2EditingController.text;
    if (passa != passb) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your password")));
      return;
    }
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: const Text("Register new account?",
          style: TextStyle(),),
          content: const Text("Are you sure?", style: TextStyle(),),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes",
              style: TextStyle(),),
              onPressed: (){
                Navigator.of(context).pop();
                registerUser();
              },),
            TextButton(
              child: const Text("No",
              style: TextStyle(),),
              onPressed: (){
                Navigator.of(context).pop();
              }
            )
          ],
        );
      });
  }
  
  void registerUser() {
    // showDialog(
    //     context: context, 
    //     builder: (BuildContext context){
    //       return const AlertDialog(
    //         title: Text("Please Wait"),
    //         content: Text("Registration in progress"),
    //       );
    //     });
   String name = _nameEditingController.text;
   String ic = _icEditingController.text;
   String email = _emailEditingController.text;
   String phone = _phoneEditingController.text;
   String passa = _passEditingController.text;

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/register_user.php"),
  body: {
    "name": name, 
    "ic": ic,
    "email": email, 
    "phone":phone,
    "password": passa
    })
  .then((response) {
  // print(response.body);
  if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
               Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) =>  const LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }
        });
    }
    }