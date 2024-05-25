import 'dart:convert';
import 'dart:io';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AddLicenseScreen extends StatefulWidget {
  final User user;
  const AddLicenseScreen({super.key, required this.user});

  @override
  State<AddLicenseScreen> createState() => AddLicenseScreenState();
}

class AddLicenseScreenState extends State<AddLicenseScreen> {
    late double screenHeight,screenWidth, cardwidth;
    File? _image;
    List<File> _imageList = [];
    int _index = 0;
    var pathAsset = "assets/images/upload.png";


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text('Add Driver\'s License',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white)),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Add Your Driver's license",
                        style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                )),
          ),
                              const SizedBox(height: 8,),
                              Text("Front & Back",
                      style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                              )),
                              const SizedBox(height: 8,),
          SizedBox(
  height: screenHeight *0.7, // Set a specific height
  child: PageView.builder(
    itemCount: 2,
    controller: PageController(viewportFraction: 0.7),
    scrollDirection: Axis.vertical,
    onPageChanged: (int index) => setState(() {
      _index = index;
    }),
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return image1();
      } else if (index == 1) {
        return image2();
      }
      return Container(); // Return a default widget in case index is neither 0 nor 1
    },
  ),
),
const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: onUpdateDialog, 
                   style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(249, 148, 23, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )
                    ),
                  child: Text("Add",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white
                  ),))
        ],
      )
    );
  }

  void onUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add your Driver License?",
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
                addIc();
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

  Future<void>_showSelectionDialog() async{
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20))),
          title: const Text("From where do you want to take the photo?"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                IconButton(
                  onPressed: _selectFromCamera, 
                  icon: const Icon(Icons.add_a_photo)),
                  const Text("Camera"),
                
                const SizedBox(
                  height: 10,
                ),
                IconButton(
                  onPressed: _selectFromGallery, 
                  icon: const Icon(Icons.add_photo_alternate)),
                  const Text("Gallery"),
              ],
            ),
          ),
        );
      }
      );
  }


   Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _selectFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _imageList.add(_image!);
      setState(() {
        
      });
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);

      setState(() {});
    }
  }

   Widget image1(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: _showSelectionDialog,
        child: Container(
          width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageList.isNotEmpty
                  ? FileImage(_imageList[0]) as ImageProvider
                  : AssetImage(pathAsset),
                fit: BoxFit.contain,
                ),
              )
        ),
      ),
    );
  }

 Widget image2(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: _showSelectionDialog,
        child: Container(
          width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageList.length > 1
                  ? FileImage(_imageList[1]) as ImageProvider
                  : AssetImage(pathAsset),
                fit: BoxFit.contain,
                ),
              )
        ),
      ),
    );
  }


void addIc(){
  if (_imageList.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please add your Driver's License")));
      return;
    }
    String base64Image1 = base64Encode(_imageList[0].readAsBytesSync());
    String base64Image2 = base64Encode(_imageList[1].readAsBytesSync());

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/add_ic.php"),
  body: {
    "user_id":widget.user.id,
    "image1": base64Image1,
    "image2": base64Image2,
  }).then((response) {
    print(response.body);
    if(response.statusCode == 200){
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfully Update IC")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to Update IC")));
      }
    } else {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Failed to Update IC")));
      Navigator.pop(context);
    }
  });
}
}