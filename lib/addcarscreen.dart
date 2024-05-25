import 'dart:convert';
import 'dart:io';
import 'package:car_buddy/cartabscreen.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class AddCarScreen extends StatefulWidget {
  final User user;
  const AddCarScreen({super.key, required this.user});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  File? _image;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _modelEditingController = TextEditingController();
  final TextEditingController _tankEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight,screenWidth, cardwidth;
  var pathAsset = "assets/images/gallery.png";
  String _selectedYear = "2024";
  String selectedType = "Others";
  String? _selected; // Change _selected type to nullable String
  final List<Map<String, dynamic>> _manufacturerList = [
  {
    "id": 0,
    "image": "assets/images/audi.jpeg",
    "name":"Audi"
  },
{
    "id": 1,
    "image": "assets/images/bentley.png",
    "name":"Bentley"
  },
  {
    "id": 2,
    "image": "assets/images/bmw.jpeg",
    "name":"BMW"
  },
{
    "id": 3,
    "image": "assets/images/byd.png",
    "name":"BYD"
  },
{
    "id": 4,
    "image": "assets/images/chery.jpeg",
    "name":"Chery"
  },
{
    "id": 5,
    "image": "assets/images/chevrolet.jpeg",
    "name":"Chevrolet"
  },
{
    "id": 6,
    "image": "assets/images/citroen.jpeg",
    "name":"Citroen"
  },
{
    "id": 7,
    "image": "assets/images/ford.png",
    "name":"Ford"
  },
{
    "id": 8,
    "image": "assets/images/greatWall.png",
    "name":"Great Wall"
  },
{
    "id": 9,
    "image": "assets/images/honda.jpeg",
    "name":"Honda"
  },
{
    "id": 10,
    "image": "assets/images/hyundai.jpeg",
    "name":"Hyundai"
  },
{
    "id": 11,
    "image": "assets/images/isuzu.png",
    "name":"Isuzu"
  },
{
    "id": 12,
    "image": "assets/images/jaguar.jpeg",
    "name":"Jaguar"
  },
{
    "id": 13,
    "image": "assets/images/jeep.jpeg",
    "name":"Jeep"
  },
{
    "id": 14,
    "image": "assets/images/kia.png",
    "name":"Kia"
  },
{
    "id": 15,
    "image": "assets/images/lexus.jpeg",
    "name":"Lexus"
  },
{
    "id": 16,
    "image": "assets/images/mazda.jpeg",
    "name":"Mazda"
  },
{
    "id": 17,
    "image": "assets/images/benz.jpeg",
    "name":"Mercendes-Benz"
  },
{
    "id": 18,
    "image": "assets/images/mitsubishi.png",
    "name":"Mitsubishi"
  },
  {
    "id": 19,
    "image": "assets/images/nissan.jpeg",
    "name":"Nissan"
  },
{
    "id": 20,
    "image": "assets/images/perodua.jpeg",
    "name":"Perodua"
  },
{
    "id": 21,
    "image": "assets/images/peugeot.jpeg",
    "name":"Peugeot"
  },
{
    "id": 22,
    "image": "assets/images/proton.jpeg",
    "name":"Proton"
  },
{
    "id": 23,
    "image": "assets/images/renault.jpeg",
    "name":"Renault"
  },
{
    "id": 24,
    "image": "assets/images/subaru.jpeg",
    "name":"Subaru"
  },
{
    "id": 25,
    "image": "assets/images/suzuki.png",
    "name":"Suzuki"
  },
{
    "id": 26,
    "image": "assets/images/tesla.png",
    "name":"Tesla"
  },
  {
    "id": 27,
    "image": "assets/images/toyota.jpeg",
    "name":"Toyota"
  },
{
    "id": 28,
    "image": "assets/images/volkswagen.jpeg",
    "name":"Volswagen"
  },
{
    "id": 29,
    "image": "assets/images/volvo.jpeg",
    "name":"Volvo"
  },
{
    "id": 30,
    "image": "assets/images/other.jpeg",
    "name":"Others"
  },

];

List<String> _generateYears() {
  List<String> years = [];
  int currentYear = DateTime.now().year;
  int startYear = currentYear - 100; // Change this to adjust the range of years

  for (int year = currentYear; year >= startYear; year--) {
    years.add(year.toString());
  }

  return years;
}

String selectedCarType = "Sedan";
  List<String> carTypeList = [
    "Sedan",
    "Hatchback",
    "Luxury",
    "Sport",    
    "SUV",
    "MPV",
  ];

  String selectedFuelType = "Gasoline";
  List<String> fuelTypeList = [
    "Gasoline",
    "Electric",
    "Hybrid",
  ];


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text("CarBuddy",
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
                                            child: Text("Name",
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
                            controller: _nameEditingController,
                            validator: (val) => val!.isEmpty
                            ? "Name must not be empty"
                            : null,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              filled: true,
                            fillColor: Colors.white,
                              labelText: "",
                              labelStyle: TextStyle(
                              ),
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
                                                    child: Text("Model",
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
                            controller: _modelEditingController,
                            validator: (val) => val!.isEmpty 
                            ? "Model name must not be empty"
                            : null,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "",
                              labelStyle: TextStyle(),
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
        "Manufacturer",
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
    const SizedBox(width: 10), // Adjust spacing between label and dropdown button
    Expanded(
      child: Column(
        children: [
          Container(
            height: 60,
            width: screenWidth,
            color: Colors.white,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: const Text("Select Manufacturer"),
                  value: _selected,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selected = newValue;
                    });
                  },
                  items: _manufacturerList.map((Map<String, dynamic> manufacturer) {
                    return DropdownMenuItem<String>(
                      value: manufacturer['name'],
                      child: Row(
                        children: [
                          Image.asset(
                            manufacturer['image'],
                            width: 50,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(manufacturer['name']),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                   underline: Container(
                    height: 1,
                    color: Colors.black, // Change underline color here
                  ),
                ),
              ),
            ),
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
        "Year",
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
    const SizedBox(width: 10), // Adjust spacing between label and dropdown button
    Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: DropdownButton<String>(
                    value: _selectedYear,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                      });
                    },
                    items: _generateYears().map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ),
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
                                                       child: Text("Type",
                                                       style: GoogleFonts.poppins(
                                                       fontWeight: FontWeight.bold,
                                                       fontSize: 20,
                                                       color: Colors.black
                                                        ),),
                                                                                          ),
                                                  ],
                                                ),
                                                Container(
                                                  color: Colors.white,
                                                  child: SizedBox(
                                                    height: 60,
                                                    width: screenWidth,
                                                    child: DropdownButton(
                                                      value: selectedCarType,
                                                      onChanged: (newValue){
                                                        setState(() {
                                                          selectedCarType = newValue!;
                                                        });
                                                      },
                                                      items: carTypeList.map((selectedCarType){
                                                        return DropdownMenuItem<String>(
                                                          value: selectedCarType,
                                                          child: Text(selectedCarType),
                                                        );
                                                      }).toList()
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Padding(
                                                     padding: const EdgeInsets.all(3.0),
                                                     child: Text("Fuel Type",
                                                     style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black
                                                       ),),
                                                                   ),
                                                  ],
                                                ),
                                                Container(
                                                  color: Colors.white,
                                                  child: SizedBox(
                                                    height: 60,
                                                    width: screenWidth,
                                                    child: DropdownButton(
                                                      value: selectedFuelType,
                                                      onChanged: (newValue){
                                                        setState(() {
                                                          selectedFuelType = newValue!;
                                                        });
                                                      },
                                                      items: fuelTypeList.map((selectedFuelType){
                                                        return DropdownMenuItem<String>(
                                                          value: selectedFuelType,
                                                          child: Text(selectedFuelType),
                                                        );
                                                      }).toList()
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Padding(
                                                       padding: const EdgeInsets.all(3.0),
                                                       child: Text("Tank Capacity",
                                                       style: GoogleFonts.poppins(
                                                       fontWeight: FontWeight.bold,
                                                       fontSize: 20,
                                                       color: Colors.black
                                                       ),),
                                                         ),
                                                  ],
                                                ),
                                                TextFormField(
                                                   textInputAction: TextInputAction.next,
                            controller: _tankEditingController,
                            validator: (val) => val!.isEmpty
                            ? "Tank capacity must not be empty"
                            : null,
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.left,
                            decoration: const InputDecoration(
                              filled: true,
                            fillColor: Colors.white,
                              suffixText: "ℓ", // Set the label text as a prefix
    suffixStyle: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 22,
      color: Colors.grey,
      
    ),
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
        CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        //CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
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
    }
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
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
                registerCar();
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
  
  void registerCar() {
   String name = _nameEditingController.text;
   String model = _modelEditingController.text;
   String tank = _tankEditingController.text;
   String base64Image = base64Encode(_image!.readAsBytesSync());

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/register_car.php"),
  body: {
    "user_id":widget.user.id.toString(),
    "name": name, 
    "model": model,
    "manufacturer": _selected, 
    "year": _selectedYear.toString(),
    "type": selectedCarType,
    "fuel": selectedFuelType, 
    "tank": tank,
    "image": base64Image
  })
  .then((response){
    print(response.body);
  if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
               Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) =>  CarTabScreen(user: widget.user,)));
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