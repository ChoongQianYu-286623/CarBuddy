import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_buddy/addinsurancescreen.dart';
import 'package:car_buddy/editinsurancescreen.dart';
import 'package:car_buddy/local_notification.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/insurance.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';

class InsuranceScreen extends StatefulWidget {
  final User user;
  final Car? car;
  const InsuranceScreen({Key? key, required this.user, required this.car}) : super(key: key);

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  late double screenHeight,screenWidth, cardwidth;
  var pathAsset = "assets/images/upload_insurance.png";
  Car? _selectedCar;
  List<Car> carList = <Car>[];
  List<Insurance> insuranceList = <Insurance>[];

  @override
  void initState(){
    super.initState();
    _loadCars();
    _loadInsurance();
    print(insuranceList.length);
  }


  @override
  Widget build(BuildContext context) {
     screenHeight = MediaQuery.of(context).size.height;
     screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text("Insurance Policy",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white)),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Center(
      child: Column(
        children: [
          // if (_selectedCar != null)
          // SizedBox(
          //           child: Text(_selectedCar!.carName,
          //           style: GoogleFonts.poppins(
          //                         fontSize: 20,
          //                         fontWeight: FontWeight.bold)),
          //         ),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(car.carName,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),),
                        ),
                        const SizedBox(width: 230), // Add SizedBox for spacing
                      ],
                    ),
                    
                  );
                }).toList(), 
                iconSize: 40, // Size of the icon
              elevation: 16,
              underline: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container( // Custom underline
                  height: 1,
                  color: Colors.grey,
                    ),
              ), // Elevation of the dropdown
              ),
            ),
          ),

          if (_selectedCar != null)
            Expanded(
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: 1, 
    itemBuilder: (context, index) {
      return Column(
        children: [
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
//Insurance policy down here
  Container(
    height: 40,
    alignment: Alignment.center,
      decoration: BoxDecoration(
                 color: const Color.fromRGBO(245, 245, 245, 1), 
              boxShadow: [
                 BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                    offset: const Offset(0, 3), // Offset of the shadow
      ),
    ],
    border: const Border(
      bottom: BorderSide(
        color: Color.fromRGBO(54, 48, 98, 1), // Color of the underline when selected
        width: 2, 
      ),
    ),
  ),
      child: Text(
        "Insurance Policy",
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromRGBO(54, 48, 98, 1)
        ),),
   
  ),
   insuranceList.isEmpty
   ? const Text("Please add insurance policy")
  : Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: insuranceList.map((insurance) {
      if(insurance.carId == _selectedCar!.carId){
        final year = extractYear(insurance.startDate);
        return Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                    child: Text("Insurance Company",
                    style: GoogleFonts.poppins(
                      fontSize:15,),
                      textAlign: TextAlign.right,),
                  ),
                  SizedBox(
                    child: Text(insuranceList[index].insuranceName,
                    style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8,),
                                SizedBox(
                  child: Text("Policy Number",
                    style: GoogleFonts.poppins(
                      fontSize:15,),
                      textAlign: TextAlign.right,),
                                ),
                  SizedBox(
                    child: Text(insuranceList[index].policyNumber,
                    style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8,),
                  SizedBox(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                  child: Text("Starting date",
                    style: GoogleFonts.poppins(
                      fontSize:15,),
                      textAlign: TextAlign.right,),
                                ),
                  SizedBox(
                    child: Text(insuranceList[index].startDate,
                    style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                  ),
                          ],
                        ),
                        const SizedBox(width: 90,),
                        Column(
                          children: [
                            SizedBox(
                  child: Text("Ending date",
                    style: GoogleFonts.poppins(
                      fontSize:15,),
                      textAlign: TextAlign.right,),
                                ),
                  SizedBox(
                    child: Text(insuranceList[index].endDate,
                    style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                      ],
                    ),
                ),
                
                Padding(
  padding: const EdgeInsets.all(8.0),
  child: Center(
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1,
        dashPattern: const [6, 6, 6, 6],
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: "${MyConfig().SERVER}/carBuddy/assets/insurance/${widget.user.id}(${_selectedCar!.carId})_$year.png",
          placeholder: (context, url) => const LinearProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),           
    ),
  ),
),
Padding(
  padding: const EdgeInsets.all(8.0),
  child: Center(
    child: ElevatedButton(
                    onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditInsuranceScreen(user: widget.user, insurance: insuranceList[index]),
    ),
  );
  if (result == true) {
    _loadInsurance();
  }
},
                     style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(249, 148, 23, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )
                      ),
                    child: Text("Update",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 25
                    ),)),
  ),
)

              ],
            ),
          );
      } else {
        return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            children: [
               Text("No insurance information found. Please add insurance policy", 
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),),
          const SizedBox(height: 10,),
           Text("If you already added insurance policy, please return to the previous page to select your car", 
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),),
            ],
          )
        );
      }
    }).toList(),
  )
  
        ],
      );
    },
  ),
),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
  onPressed: () async {
    if (_selectedCar != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddInsuranceScreen(user: widget.user, car: _selectedCar),
        ),
      );
      if (result == true) {
        _loadInsurance();
      }
    } else {
      const Center(child: Text("Please select a car"));
    }
  },
  tooltip: 'Add Insurance',
  hoverElevation: 10,
  backgroundColor: const Color.fromRGBO(249, 148, 23, 1),   
  shape: const CircleBorder(),
  child: const Icon(Icons.add, color: Colors.white),
),

  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String extractYear(String date) {
  DateTime dateTime = DateTime.parse(date);
  return dateTime.year.toString();
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
            _selectedCar = carList.isNotEmpty ? carList.first : null;
          });
        }
      }
    });
}

void _loadInsurance() {
  http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/load_insurance.php"),
    body: {
      "user_id" : widget.user.id.toString(), // Ensure user_id is converted to String
      "car_id":widget.car?.carId.toString(),
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if(jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          var insuranceData = extractdata as List; // Cast extractdata to List
          List<Insurance> insurance = insuranceData.map((insuranceJson) => Insurance.fromJson(insuranceJson)).toList();
          setState(() {
            insuranceList = insurance;
          });

          // Schedule notifications for each insurance
        for (var insurance in insuranceList) {
            // For testing, set the endDate to a few minutes in the future
            DateTime endDate = DateTime.parse(insurance.endDate);
            DateTime notificationDate = endDate.subtract(const Duration(days: 14));

          // Check if maintenanceDate is in the future before scheduling
          if (notificationDate.isAfter(DateTime.now())) {
            print("notification success");
            // Schedule the notification 1 day before the maintenance date
            LocalNotifications.showScheduleNotification2(
              title: "Insurance Expiry Reminder",
              body: "Your insurance policy for ${_selectedCar?.carName} is expiring on ${insurance.endDate}",
              payload: insurance.policyNumber,
              scheduledDate: notificationDate,
            );
          } else {
            print('Insurance expiry date is in the past, no notification scheduled.');
          }
        }
        }
      }
    });
}
}