import 'package:car_buddy/addlicensescreen.dart';
import 'package:car_buddy/editprofilescreen.dart';
import 'package:car_buddy/loginscreen.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;
  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight,screenWidth, cardwidth;
  bool isDisable = false;
  var pathAsset = "assets/images/profile.png";
  var pathAsset2 = "assets/images/upload.png";

  @override
  void initState(){
    super.initState();
    print("Profile");
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose");
    if(widget.user.id == 'na'){
      isDisable = true;
    } else {
      isDisable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text(maintitle,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white)),
        actions: [
          IconButton(
            onPressed: _onlogout, 
            icon: const Icon(Icons.logout,color: Colors.white,))
        ],
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
                    children: [
                      Text("Driver's license",
                      style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              )),
                              const SizedBox(height: 8,),
                              Text("Front",
                      style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )),
                      Card(
                        child: SizedBox(
                          height: screenHeight*0.3,
                          width: screenWidth ,
                          child: 
                          ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // Adjust the value as needed
        child: CachedNetworkImage(
          width: screenWidth,
          height: screenHeight * 0.2,
          fit: BoxFit.cover,
          imageUrl: "${MyConfig().SERVER}/carBuddy/assets/license/${widget.user.id}front.png",
          placeholder: (context, url) => const LinearProgressIndicator(),
          errorWidget: (context, url, error) {
            return Center(
            child: Text(
              "Please add your Driver's license",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
          },
        ),
      )
                        ),
                      ),
                      const SizedBox(height: 8,),
                              Text("Back",
                      style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                              )),
                    Card(
                        child: SizedBox(
                          height: screenHeight*0.3,
                          width: screenWidth ,
                          child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // Adjust the value as needed
        child: CachedNetworkImage(
          width: screenWidth,
          height: screenHeight * 0.2,
          fit: BoxFit.cover,
          imageUrl: "${MyConfig().SERVER}/carBuddy/assets/license/${widget.user.id}back.png",
          placeholder: (context, url) => const LinearProgressIndicator(),
          errorWidget: (context, url, error) {
            return Center(
            child: Text(
              "Please add your Driver's license",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
          },
        ),
      )
                        ),
                      ),
        
              
                    ],
                  ),
        ) // down one
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.list_view,
        overlayColor: Colors.white,
        overlayOpacity: 0.7,
        backgroundColor: const Color.fromRGBO(249, 148, 23, 1),        
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: Icon(Icons.edit),
            backgroundColor: Color.fromARGB(112, 249, 147, 23),
            label: 'Update Profile',
            labelStyle: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.bold),
            onTap: () {
      Navigator.push(context,
              MaterialPageRoute(builder: (content)=> EditProfileScreen(user: widget.user,)));
    },
          ),
          SpeedDialChild(
            child: Icon(Icons.credit_card),
            backgroundColor: Color.fromARGB(112, 249, 147, 23),
            label: 'Add Ic',
            labelStyle: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.bold),
            onTap: () {
      Navigator.push(context,
              MaterialPageRoute(builder: (content)=> AddLicenseScreen(user: widget.user,)));
    },
          ),
        ],
      ),
    );
  }

  void _onlogout() {
    Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content)=> const LoginScreen()));
  }


}