import 'dart:convert';
import 'dart:io';
import 'package:car_buddy/insurancescreen.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddInsuranceScreen extends StatefulWidget {
  final User user;
  final Car? car;
  const AddInsuranceScreen({super.key, required this.user,required this.car});

  @override
  State<AddInsuranceScreen> createState() => _AddInsuranceScreenState();
}

class _AddInsuranceScreenState extends State<AddInsuranceScreen> {
  late double screenHeight,screenWidth, cardwidth;
  File? _image;
  final TextEditingController _companyEditingController = TextEditingController();
  final TextEditingController _policyEditingController = TextEditingController();
  final TextEditingController _startdateEditingController = TextEditingController();
  final TextEditingController _enddateEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var pathAsset = "assets/images/upload_insurance.png";
  DateTime? _startDate;
  DateTime? _endDate;
  List<Car> carList = <Car>[];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text("Add Insurance Policy",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white))),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                        onTap: _showSelectionDialog,
                        child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Center(
                  child: Card(
                    child: Container(
                      height: screenHeight*0.3,
                        width: screenWidth*0.8,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image == null
                                ? AssetImage(pathAsset)
                                : FileImage(_image!) as ImageProvider,
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                ),
              ),
                      ),
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("Insurance Company Name",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                            ),),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                         textInputAction: TextInputAction.next,
                            controller: _companyEditingController,
                            validator: (val) => val!.isEmpty
                            ? "Company name must not be empty"
                            : null,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                            decoration: const InputDecoration(
                              filled: true,
                            fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                              ),
                              borderSide: BorderSide(width: 1)
                                                 ),
                              focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                                                ),

                                                 const SizedBox(height: 10),
                                         Row(
                                                  children: [
                                                    Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Text("Policy Number",
                                                    style: GoogleFonts.poppins(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                    ),),
                                                    ),
                                                  ],
                                                ),
                                                TextFormField(
                                                   textInputAction: TextInputAction.next,
                            controller: _policyEditingController,
                            validator: (val) => val!.isEmpty 
                            ? "Policy number must not be empty"
                            : null,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                              ),
                              borderSide: BorderSide(width: 1)
                                                 ),
                              focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                                                ),
                                        const SizedBox(height: 10),
Row(
  children: [
    Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        "Starting Date",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
  ],
),
Row(
  children: [
    const SizedBox(width: 10), // Adjust spacing between label and date picker button
    Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                   textInputAction: TextInputAction.next,
                  controller: _startdateEditingController,
                    style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.calendar_month),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate((DateTime selectedDate) {
                    setState(() {
                      _startDate = selectedDate;
                      _startdateEditingController.text =
                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    });
  });
},
                )
              ),
            ],
          ),
        ],
      ),
    ),
  ],
),
const SizedBox(height: 10),
Row(
  children: [
    Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        "Ending Date",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
  ],
),
Row(
  children: [
    const SizedBox(width: 10), // Adjust spacing between label and date picker button
    Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                   textInputAction: TextInputAction.next,
                  controller: _enddateEditingController,
                    style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.calendar_month),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate((DateTime selectedDate) {
                    setState(() {
                      _endDate = selectedDate;
                      _enddateEditingController.text =
                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    });
  });
},
                )
              ),
            ],
          ),
        ],
      ),
    ),
  ],
),      
                                    ],
                                  )
                                  ),
                          ),
                        ],
                      )
                     ),
                ],
                
              ),
              const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: onRegisterDialog, 
                   style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(249, 148, 23, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )
                    ),
                  child: Text("Add",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28
                  ),))
            ],
          ),
        ),
    );
  }

  Future<void> _selectDate(void Function(DateTime) onDateSelected) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    onDateSelected(pickedDate);
  }
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

      setState(() {});
       int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);

      setState(() {});
    }
  }


  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_endDate != null && _startDate != null) {
                      if (_startDate!.isAfter(_endDate!)) {
                        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Starting date cannot be after ending date")));
      return;
                      }
                    }
       if (_startDate != null && _endDate != null) {
                      if (_endDate!.isBefore(_startDate!)) {
                        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Ending date cannot be before starting date")));
      return;
                      }
                    }

    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: const Text("Register this car?",
          style: TextStyle(),),
          content: const Text("Are you sure?", style: TextStyle(),),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes",
              style: TextStyle(),),
              onPressed: (){
                Navigator.of(context).pop();
                addInsurance();
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
  
  void addInsurance() {
   String insuranceName = _companyEditingController.text;
   String policyNumber = _policyEditingController.text;
   String base64Image = base64Encode(_image!.readAsBytesSync());

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/add_insurance.php"),
  body: {
    "user_id":widget.user.id.toString(),
    "car_id":widget.car?.carId.toString(),
    "insuranceName":insuranceName,
    "policyNumber":policyNumber,
    "startDate":_startDate!.toString(),
    "endDate":_endDate!.toString(),
    "image":base64Image
  })
  .then((response){
    print(response.body);
  if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Insurance Policy Successfully Added")));
               Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) =>  InsuranceScreen(user: widget.user, car: widget.car)));
                  Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to add Insurance Policy")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to add Insurance Policy")));
        Navigator.pop(context);
      }
  });
  }
}