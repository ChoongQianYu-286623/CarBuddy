import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_buddy/cartabscreen.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/models/car.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditCarScreen extends StatefulWidget {
  final User user;
  final Car? car;
  const EditCarScreen({super.key, required this.user, required this.car});

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  File? _image;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _modelEditingController = TextEditingController();
  final TextEditingController _tankEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight,screenWidth, cardwidth;
  var pathAsset = "assets/images/gallery.png";
  List<Car> carList = <Car>[];
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
  void initState() {
    super.initState();
    _nameEditingController.text = widget.car!.carName.toString();
    _modelEditingController.text = widget.car!.carModel.toString();
    _selected = widget.car!.carManufacturer.toString();
    _selectedYear = widget.car!.carYear.toString();
    selectedCarType = widget.car!.carType.toString();
    selectedFuelType = widget.car!.carFuelType.toString();
    _tankEditingController.text = widget.car!.carTank.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text("Car Details",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white))),
          backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
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
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        color: Colors.white,
                        fontSize: 28
                      ),)),
                      const SizedBox(width: 20,),
                     IconButton(
                        onPressed: (){
                          onDeleteDialog(widget.car!.carId);
                        }, 
                        icon: const Icon(Icons.delete,color: Colors.black,))
                  ],
                ),
            ],
          ),
        ),
    );
  }

  String carImagePath(int carId) {
  return "${MyConfig().SERVER}/carBuddy/assets/cars/$carId.png";
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
            "Update car details?",
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
                updateDetails();
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

  void updateDetails() {
  String newname = _nameEditingController.text;
  String newmodel = _modelEditingController.text;
  String newtank = _tankEditingController.text.toString();

  // // Convert newtank to an integer
  // int newTankValue = int.tryParse(newtank) ?? 0; // Use default value if parsing fails

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/update_details.php"),
    body: {
      "carid": widget.car!.carId.toString(),
      "newname": newname,
      "newmodel": newmodel,
      "newmanufacturer": _selected,
      "newyear": _selectedYear,
      "newtype": selectedCarType,
      "newfueltype": selectedFuelType,
      "newtank": newtank.toString(), // Convert integer to string
      // "image": base64Image
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Update Success")));
Navigator.pop(context);
// Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (context) => CarTabScreen(user: widget.user),
//   ),
// );  
setState(() {
    widget.car!.carName = newname;
    widget.car!.carModel = newmodel;
    widget.car!.carManufacturer = _selected!;
    widget.car!.carType = _selectedYear!;
    widget.car!.carType = selectedCarType;
    widget.car!.carFuelType = selectedFuelType;
    widget.car!.carTank = newtank; // Assign the integer value directly
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

void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this car?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
              deleteCar(index);  
              Navigator.of(context).pop();
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

  void deleteCar(int index) {
    print("Deleting car with ID: ${widget.car!.carId}");
    http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/delete_car.php"),
        body: {
          "carid":widget.car!.carId.toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
      Navigator.pop(context);
// Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (context) => CarTabScreen(user: widget.user),
//   ),
// );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

}