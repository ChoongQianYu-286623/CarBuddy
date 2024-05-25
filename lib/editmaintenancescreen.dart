import 'dart:convert';
import 'package:car_buddy/maintenancescreen.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/maintenance.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EditMaintenanceScreen extends StatefulWidget {
  final User user;
  final Car? car;
  final Maintenance maintenance;
  const EditMaintenanceScreen({Key? key, required this.user, required this.car, required this.maintenance}) : super(key: key);

  @override
  State<EditMaintenanceScreen> createState() => _EditMaintenanceScreenState();
}

class _EditMaintenanceScreenState extends State<EditMaintenanceScreen> {
late double screenHeight,screenWidth, cardwidth;
  final TextEditingController _servicetypeEditingController = TextEditingController();
  final TextEditingController _workshopEditingController = TextEditingController();
  final TextEditingController _dateEditingController = TextEditingController();
  final TextEditingController _locationEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var pathAsset = "assets/images/upload_insurance.png";
  DateTime? _date;
  List<Car> carList = <Car>[];
    List<Maintenance> maintenanceList = <Maintenance>[];


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
  void initState() {
    super.initState();
    _servicetypeEditingController.text = widget.maintenance.maintenanceType.toString();
    _workshopEditingController.text = widget.maintenance.maintenanceWorkshop.toString();
     _dateEditingController.text = widget.maintenance.maintenanceDate.toString();
    _locationEditingController.text = widget.maintenance.maintenanceLocation.toString();
    selectedState = widget.maintenance.maintenanceState.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text("Edit Maintenance Record",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white))),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        body: SingleChildScrollView(
          child: Padding(
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
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
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
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text("Service Type",
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
                                controller: _servicetypeEditingController,
                                validator: (val) => val!.isEmpty
                                ? "Service type must not be empty"
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
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text("Workshop",
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
                                controller: _workshopEditingController,
                                validator: (val) => val!.isEmpty
                                ? "Workshop must not be empty"
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
                        onPressed: () {
                          onDeleteDialog(widget.maintenance.maintenanceId);
                        }, 
                        icon: const Icon(Icons.delete,color: Colors.black,))
                  ],
                )
                ],
              ),
            ),
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
            "Update maintenance details?",
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
                updateMaintenance();
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

  void updateMaintenance() {
  String newDate = _dateEditingController.text;
  String newType = _servicetypeEditingController.text;
  String newWorkshop = _workshopEditingController.text.toString();
  String newLocation = _locationEditingController.text.toString();  

  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/update_maintenance.php"),
    body: {
      "userid":widget.user.id.toString(),
      "carid": widget.car?.carId.toString(),
      "maintenanceid":widget.maintenance.maintenanceId.toString(),
      "newDate":newDate,
      "newType":newType,
      "newWorkshop":newWorkshop,
      "newLocation":newLocation,
      "newState": selectedState
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Update Success")));
Navigator.pop(context, true);
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => MaintenanceScreen(user: widget.user,car: widget.car,),
  ),
);   
  setState(() {
    widget.maintenance.maintenanceDate = newDate;
    widget.maintenance.maintenanceType = newType;  
    widget.maintenance.maintenanceWorkshop = newWorkshop;  
    widget.maintenance.maintenanceLocation = newLocation;  
    widget.maintenance.maintenanceState = selectedState;  
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

void onDeleteDialog(String maintenanceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this maintenance record?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteMaintenance(maintenanceId);
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

  void deleteMaintenance(String maintenanceId) {
    http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/delete_maintenance.php"),
        body: {
          "maintenanceid":widget.maintenance.maintenanceId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
              Navigator.pop(context, true);
              Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MaintenanceScreen(user: widget.user, car: widget.car),
        ),
      );
          //_loadMaintenance(index);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}

