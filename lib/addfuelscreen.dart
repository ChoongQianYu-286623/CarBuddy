import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_buddy/fueltabscreen.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddFuelScreen extends StatefulWidget {
  final User user;
  final Car? car;
  const AddFuelScreen({super.key, required this.user,required this.car});

  @override
  State<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends State<AddFuelScreen> {
  late double screenHeight,screenWidth, cardwidth;
  final _formKey = GlobalKey<FormState>();
  DateTime? _date;
  Car? _selectedCar;
  List<Car> carList = <Car>[];
  final TextEditingController _dateEditingController = TextEditingController();
  final TextEditingController _costEditingController = TextEditingController();
  final TextEditingController _literEditingController = TextEditingController();
  final TextEditingController _mileageEditingController = TextEditingController();
  final TextEditingController _companyEditingController = TextEditingController();
  final TextEditingController _locationEditingController = TextEditingController();

   String selectedPetrol = "RON 95";
  List<String> petrolList = [
    "RON 97",
    "RON 95",
    "Diesel",
    "Others",
  ];

   String selectedState = "Kedah";
  List<String> stateList = [
    "Johor",
    "Kedah",
    "Kelantan",
    "Kuala Lumpur",
    "Labuan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Pulau Pinang",
    "Perak",
    "Perlis",
    "Putrajaya",
    "Sabah",
    "Sarawak",
    "Selangor",
    "Terengganu",
  ];

  @override
  void initState(){
    super.initState();
    // print(widget.user.name);
    // print("Buyer");
    _loadCars();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    _selectedCar = carList.isNotEmpty ? carList.first : null;
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text("Add Fuel History",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white
          ))),
          backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
          body: SingleChildScrollView(
            child:  Column(
                children: [ 
                  Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                 color: Colors.white,
              boxShadow: [
                 BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset of the shadow
      ),
    ],
  ),
              child: DropdownButton<Car>(
                value: _selectedCar,
                onChanged: (Car? car) {
                  setState(() {
                    _selectedCar = car;
                  });
                },
                items: carList.map<DropdownMenuItem<Car>>((Car car) {
                  return DropdownMenuItem<Car>(
                    value: car,
                    child: Row(
                      children: [
                        Text(car.carName,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                        ),),
                        const SizedBox(width: 250), // Add SizedBox for spacing
                      ],
                    ),
                    
                  );
                }).toList(), 
                iconSize: 40, // Size of the icon
              elevation: 16,
              underline: Container( // Custom underline
                height: 2,
                color: Colors.white,
    ), // Elevation of the dropdown
              ),
            ),
          ),
          if (_selectedCar != null)
            Padding(
  padding: const EdgeInsets.all(8.0),
  child: Material(
    elevation: 4,
    borderRadius: BorderRadius.circular(5.0),
    child: SizedBox(
      width: screenWidth,
      height: screenHeight * 0.25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // Adjust the value as needed
        child: CachedNetworkImage(
          width: screenWidth,
          height: screenHeight * 0.2,
          fit: BoxFit.cover,
          imageUrl: "${MyConfig().SERVER}/carBuddy/assets/cars/${_selectedCar!.carId}.png",
          placeholder: (context, url) => const LinearProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    ),
  ),
),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [ 
                           Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "Date",
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
                    controller: _dateEditingController,
                      style: GoogleFonts.poppins(
                                  fontSize: 15,
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
                        _date = selectedDate;
                        _dateEditingController.text =
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
                     Row(
                       children: [
                         Flexible(
                          flex: 5,
                           child: Column(
                            children: [ 
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                  "Cost (RM)",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                                              ),
                                                       ),
                                ],
                              ),
                           TextFormField(
                                textInputAction: TextInputAction.next,
                                             controller: _costEditingController,
                                             validator: (val) => val!.isEmpty
                                             ? "Cost must not be empty"
                                             : null,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.left,
                                 style: GoogleFonts.poppins(
                                  fontSize: 15,
                                ),
                               decoration: const InputDecoration(
                                               filled: true,
                                             fillColor: Colors.white,
                                             suffixText: ".00",
                           suffixStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
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
                           ),
                         ),
                         const SizedBox(width: 10.0),
                          Flexible(
                            flex: 5,
                            child: Column(
                            children: [ 
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                  "Liters (ℓ)",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                                              ),
                                                        ),
                                ],
                              ),
                                TextFormField(
                                textInputAction: TextInputAction.next,
                                             controller: _literEditingController,
                                             validator: (val) => val!.isEmpty
                                             ? "Volume must not be empty"
                                             : null,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.left,
                                 style: GoogleFonts.poppins(
                                  fontSize: 15,
                                ),
                               decoration: const InputDecoration(
                                               filled: true,
                                             fillColor: Colors.white,
                                             suffixText: ".00",
                                                     suffixStyle: TextStyle(
                                                 fontWeight: FontWeight.normal,
                                                 fontSize: 15,
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
                                                     ),
                          ),
                       ],
                     ),
                    Row(
                                                  children: [
                                                    Padding(
                                                       padding: const EdgeInsets.all(3.0),
                                                       child: Text("Type of petrol",
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
                                                      value: selectedPetrol,
                                                      onChanged: (newValue){
                                                        setState(() {
                                                          selectedPetrol = newValue!;
                                                        });
                                                      },
                                                      items: petrolList.map((selectedPetrol){
                                                        return DropdownMenuItem<String>(
                                                          value: selectedPetrol,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(selectedPetrol,
                                                                style: GoogleFonts.poppins(
                                                                  fontSize: 15,
                                                                ),),
                                                              ),
                                                              const SizedBox(width: 250),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                      iconSize: 40, // Size of the icon
              elevation: 16,
              underline: Container( // Custom underline
                height: 2,
                color: Colors.white,
    ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("Mileage (KM)",
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
                            controller: _mileageEditingController,
                            validator: (val) => val!.isEmpty
                            ? "Mileage must not be empty"
                            : null,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
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
                                                Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("Petrol Company",
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
                            ? "Petrol Company must not be empty"
                            : null,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
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
                                                Row(
                       children: [
                         Flexible(
                          flex: 5,
                           child: Column(
                            children: [ 
                              Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text("Location",
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
                                controller: _locationEditingController,
                                validator: (val) => val!.isEmpty
                                ? "Location must not be empty"
                                : null,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.left,
                                 style: GoogleFonts.poppins(
                                  fontSize: 15,
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
                            ],
                           ),
                         ),
                         const SizedBox(width: 10.0),
                          Flexible(
                            flex: 5,
                            child: Column(
                            children: [ 
                              Row(
                                                  children: [
                                                    Padding(
                                                       padding: const EdgeInsets.all(3.0),
                                                       child: Text("State",
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
                                                      value: selectedState,
                                                      onChanged: (newValue){
                                                        setState(() {
                                                          selectedState = newValue!;
                                                        });
                                                      },
                                                      items: stateList.map((selectedState){
                                                        return DropdownMenuItem<String>(
                                                          value: selectedState,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(selectedState,
                                                                style: GoogleFonts.poppins(
                                                                  fontSize: 15,
                                                                ),),
                                                              ),
                                                              const SizedBox(width: 5),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                      iconSize: 20, // Size of the icon
              elevation: 16,
              underline: Container( // Custom underline
                height: 1,
                color: Colors.black,
    ),
                                                    ),
                                                  ),
                                                ),
                            ],
                                                     ),
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
                      )),
                  )
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

void _loadCars() {
  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/load_car.php"),
    body: {
      "user_id" : widget.user.id.toString(), // Ensure user_id is converted to String
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if(jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          var carsData = extractdata as List; // Cast extractdata to List
          List<Car> cars = carsData.map((carJson) => Car.fromJson(carJson)).toList();
          setState(() {
            carList = cars;
          });
        }
      }
    });
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
          title: const Text("Add this fuel history?",
          style: TextStyle(),),
          content: const Text("Are you sure?", style: TextStyle(),),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes",
              style: TextStyle(),),
              onPressed: (){
                Navigator.of(context).pop();
                addFuel();
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

void addFuel() {
   String date = _dateEditingController.text;
   String cost = _costEditingController.text;
   String volume = _literEditingController.text;
   String mileage = _mileageEditingController.text;
   String company = _companyEditingController.text;
   String location = _locationEditingController.text;

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/add_fuel.php"),
  body: {
    "user_id":widget.user.id.toString(),
    "car_id":widget.car?.carId.toString(),
    "date":date,
    "cost":cost,
    "volume":volume,
    "type": selectedPetrol,
    "mileage":mileage,
    "company":company,
    "location":location,
    "state": selectedState,
  })
  .then((response){
    print(response.body);
  if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Fuel History Successfully Added")));
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (content) =>  FuelTabScreen(user: widget.user)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to add Fuel History")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to add Fuel History")));
        Navigator.pop(context);
      }
  });
  }


}