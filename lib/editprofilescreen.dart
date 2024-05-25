import 'dart:convert';

import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String maintitle = "Profile";
  late double screenHeight,screenWidth, cardwidth;
  bool isDisable = false;
  var pathAsset = "assets/images/profile.jpeg";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _icEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();

@override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.user.name.toString();
    _icEditingController.text = widget.user.ic.toString();
    _emailEditingController.text = widget.user.email.toString();
    _phoneEditingController.text = widget.user.phone.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text('Edit Profile',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white)),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: Column(
            children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    height: screenHeight*0.3,
                    width: screenWidth,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(80)
                      ),
                      color: Color.fromRGBO(77, 76, 125, 1),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(pathAsset),
                            radius: 70,
                          ),
                        ),
                        Text(widget.user.name.toString(),
                         style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                            ))
                      ],
                    ),
                    ),
              //purple up one
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
                    children: [
                      Text("Update Profile",
                      style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                      Padding(padding: const EdgeInsets.all(8.0),
               child: Card(
                 color: Colors.white,
                //  shape: const RoundedRectangleBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(30))
                //  ),
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
                                color: Colors.black
                              ),),
                            ),
                            TextFormField(
                              onFieldSubmitted: (v){},
                  controller: _nameEditingController,
                  validator: (val) => val!.isEmpty || (val.length < 5)
                  ? "Name must be longer than 5"
                  : null,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                   style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                  fillColor: Color.fromRGBO(77, 76, 125, 70),
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
                    hintStyle: TextStyle(
                      color: Colors.white, // Set the color of the entered text
                    ),
                  ),
                ),
                 const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("I/C Number",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black
                              ),),
                            ),
                TextFormField(
                  onFieldSubmitted: (v){},
                  controller: _icEditingController,
                  validator: (val) => val!.isEmpty || val.length != 12 || val.contains("-")
                  ? "Please enter a valiid I/C number without - in between"
                  : null,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(77, 76, 125, 70),
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
                    hintStyle: TextStyle(
                      color: Colors.white, // Set the color of the entered text
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Email",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black
                              ),),
                            ),
                TextFormField(
                  onFieldSubmitted: (v){},
                  controller: _emailEditingController,
                  validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                  ? "Please enter a valid email"
                  : null,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(77, 76, 125, 70),
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
                    hintStyle: TextStyle(
                      color: Colors.white, // Set the color of the entered text
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Contact Number",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.black
                              ),),
                            ),
                TextFormField(
                  onFieldSubmitted: (v){},
                  controller: _phoneEditingController,
                  validator: (val) => val!.isEmpty || (val.length < 10)
                  ? "phone must be longer than 10"
                  : null,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                  fillColor: Color.fromRGBO(77, 76, 125, 70),
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
                    hintStyle: TextStyle(
                      color: Colors.white, // Set the color of the entered text
                    ),
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
                  onPressed: onUpdateDialog, 
                   style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(249, 148, 23, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )
                    ),
                  child: Text("Update",
                  style: GoogleFonts.poppins(
                    color: Colors.white
                  ),))
                    ],
                  ),
        ) // down one
            ],
          ),
        ),
      ),
    );
  }

  void onUpdateDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update your profile?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateProfile();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void updateProfile() {
    String newname = _nameEditingController.text;
    String newic = _icEditingController.text;
    String newemail = _emailEditingController.text;
    String newphone = _phoneEditingController.text;

     http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/update_profile.php"),
     body: {
      "userid":widget.user.id,
      "newname": newname,
      "newic": newic,
      "newemail": newemail,
      "newphone": newphone,
      // "image": base64Image
     }).then((response) {
    print(response.body);
    if(response.statusCode == 200){
      var jsondata = jsonDecode(response.body);
    if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          Navigator.pop(context);
          setState(() {
            widget.user.name = newname;
            widget.user.ic = newic;
            widget.user.email = newemail;
            widget.user.phone = newphone;
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
  });
  }
}