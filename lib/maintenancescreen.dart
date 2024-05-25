import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_buddy/addmaintenancescreen.dart';
import 'package:car_buddy/editmaintenancescreen.dart';
import 'package:car_buddy/local_notification.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/maintenance.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MaintenanceScreen extends StatefulWidget {
  final User user;
  final Car? car;
  const MaintenanceScreen({super.key, required this.user, required this.car});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  late double screenHeight,screenWidth, cardwidth;
  Car? _selectedCar;
  List<Car> carList = <Car>[];
  List<Maintenance> maintenanceList = <Maintenance>[];
  String _selectedHistory = "Upcoming";

   @override
  void initState(){
    super.initState();
    _loadCars();
    _loadMaintenance();
  }
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
        title: Text("Car Maintenance",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white)),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
    body: Center(
      child: Column(
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
            Flexible(
              flex: 1,
  child: ListView.builder(
    itemCount: 1, // Use carList.length as the itemCount
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

        ],
      );
    },
  ),
),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
  decoration: BoxDecoration(
    color: const Color.fromRGBO(245, 245, 245, 1),
    border: Border(
      bottom: BorderSide(
        color: _selectedHistory == "Upcoming"
            ? const Color.fromRGBO(54, 48, 98, 1) // Color of the underline when selected
            : Colors.transparent, // Transparent color when not selected
        width: 2, // Thickness of the underline
      ),
    ),
  ),
  child: TextButton(
    onPressed: () {
      setState(() {
        _selectedHistory = "Upcoming";
      });
    },
    child: Text(
      'Upcoming',
      style: GoogleFonts.poppins(
        color: _selectedHistory == "Upcoming"
            ? const Color.fromRGBO(54, 48, 98, 1) // Color of the text when selected
            : Colors.grey, // Default color of the text
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

              Container(
                decoration: BoxDecoration(
    color: const Color.fromRGBO(245, 245, 245, 1),
    border: Border(
      bottom: BorderSide(
        color: _selectedHistory == "Previous"
            ? const Color.fromRGBO(54, 48, 98, 1) // Color of the underline when selected
            : Colors.transparent, // Transparent color when not selected
        width: 2, // Thickness of the underline
      ),
    ),
  ),
                child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedHistory = "Previous";
                });
              },
              child: Text('Previous',
              style: GoogleFonts.poppins(
                color: _selectedHistory == "Previous"
                  ? const Color.fromRGBO(54, 48, 98, 1)
                  : Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
            ),
              ),
            ],
          ),
        ),
        if(_selectedCar != null)
  Flexible(
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: maintenanceList.length,
      itemBuilder: (context, index) {
        Maintenance maintenance = maintenanceList[index];

        // Check if the carId of the maintenance record matches the selected car's carId
        if (maintenance.carId == _selectedCar!.carId.toString()) {
          // Parse maintenanceDate into DateTime object
          List<String> parts = maintenance.maintenanceDate.split('/');
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          DateTime maintenanceDateTime = DateTime(year, month, day);

          DateTime currentDate = DateTime.now();

          // Check if maintenanceDate is in the past or future
          bool isPastMaintenance = maintenanceDateTime.isBefore(currentDate);
          bool isFutureMaintenance = maintenanceDateTime.isAfter(currentDate);

          // Check the selected history (Upcoming or Previous)
          bool showUpcoming = _selectedHistory == "Upcoming";

          // Condition to show the maintenance based on selected history
          if ((showUpcoming && isFutureMaintenance) || (!showUpcoming && isPastMaintenance)) {
            // Check if maintenance is upcoming to enable navigation
            bool isUpcoming = showUpcoming && isFutureMaintenance;
            return GestureDetector(
              onTap: isUpcoming ? () {
                // Navigate to EditMaintenanceScreen only for upcoming maintenance
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditMaintenanceScreen(user: widget.user, car: _selectedCar, maintenance: maintenance,),
                  ),
                );
              } : null, // Disable onTap for past maintenance
              child: Card(
                // Customize card properties here
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            maintenanceList[index].maintenanceType,
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            maintenanceList[index].maintenanceDate,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                const Icon(Icons.store),
                                Text(
                                  maintenanceList[index].maintenanceWorkshop,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                const Icon(Icons.location_on),
                                Text(
                                  maintenanceList[index].maintenanceLocation,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  ", ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  maintenanceList[index].maintenanceState,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    // ElevatedButton(
                    //   onPressed: (){
                    //     LocalNotifications.showSimpleNotification(title: "CarBuddy", body: "Simple Push Notification", payload: "This is simple test");
                    //   }, 
                    //   child: Text("Test Simple"))
                    ],
                  ),
                ),
              ),
            );
          } else {
            // Return an empty container if maintenance is not to be shown
            return Container();
          }
        } else {
          // If carId does not match, return an empty container
          return Container();
        }
      },
    ),
  ),

        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {
    if (_selectedCar != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddMaintenanceScreen(user: widget.user, selectedCar: _selectedCar),
        ),
      );
    } else {
      // Handle case where no car is selected
      // Show a dialog or a snackbar informing the user to select a car first
    }
  },

    tooltip: 'Add Maintenance',
    hoverElevation: 10,
    backgroundColor: const Color.fromRGBO(249, 148, 23, 1),   
    shape: const CircleBorder(),
    child: const Icon(Icons.add,color: Colors.white,),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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

void _loadMaintenance() {
  http.post(
    Uri.parse("${MyConfig().SERVER}/carBuddy/php/load_maintenance.php"),
    body: {
      "user_id": widget.user.id.toString(),
      "car_id": widget.car?.carId.toString(),
    },
  ).then((response) {
    print(response.body);
    maintenanceList.clear();
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        var maintenanceData = extractdata as List; // Cast extractdata to List
        List<Maintenance> maintenance = maintenanceData
            .map((maintenanceJson) => Maintenance.fromJson(maintenanceJson))
            .toList();
        setState(() {
          maintenanceList = maintenance;
        });

        // Schedule notifications for each maintenance
        for (var maintenance in maintenanceList) {
          List<String> parts = maintenance.maintenanceDate.split('/');
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          DateTime maintenanceDate = DateTime(year, month, day);

          // Check if maintenanceDate is in the future before scheduling
          if (maintenanceDate.isBefore(DateTime.now())) {
            // Schedule the notification 1 day before the maintenance date
            LocalNotifications.showScheduleNotification(
              title: "Upcoming Maintenance",
              body: "Maintenance for ${maintenance.maintenanceType} for ${_selectedCar?.carName} is scheduled on ${maintenance.maintenanceDate}",
              payload: maintenance.maintenanceId.toString(),
              scheduledDate: maintenanceDate,
            );
          } else {
            print('Maintenance date is in the past, no notification scheduled.');
          }
        }
      }
    }
  });
}


}