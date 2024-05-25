import 'dart:convert';
import 'package:car_buddy/addcarscreen.dart';
import 'package:car_buddy/editcarscreen.dart';
import 'package:car_buddy/insurancescreen.dart';
import 'package:car_buddy/maintenancescreen.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class CarTabScreen extends StatefulWidget {
  final User user;
  const CarTabScreen({super.key, required this.user});

  @override
  State<CarTabScreen> createState() => _CarTabScreenState();
}

class _CarTabScreenState extends State<CarTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Car";
  List<Car> carList = <Car>[];
  late double screenHeight,screenWidth, cardwidth;
   Car? _selectedCar;

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
   
  @override
  void initState(){
    super.initState();
    _loadCars();
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose");
  }

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
      body: RefreshIndicator(
        onRefresh: ()async{
          _loadCars();
        }, // Refresh indicator callback
        child: carList.isEmpty 
        ? Center(
          child: Text("You haven't add a car", style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.grey))
          )
        : Center(
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
              Expanded(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(
          color: const Color.fromRGBO(245, 245, 245, 1),
        ),
        children: [TableRow(
          children: [
            TableCell(
              child: Text(
                "Model", 
                style: GoogleFonts.poppins(fontSize: 15),)
              ),
              TableCell(
              child: Text(
                "Manufacturer", 
                style: GoogleFonts.poppins(fontSize:15))
              ),
              ]
        ),
        TableRow(
          children: [
            TableCell(
              child: Text(
                _selectedCar!.carModel, 
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold),)
              ),
             TableCell(
        child: Row(
          children: [
              Image.asset(
                // Retrieve the image path from _manufacturerList based on the selected manufacturer name
                _manufacturerList.firstWhere((manufacturer) => manufacturer['name'] == _selectedCar!.carManufacturer)['image'],
                width: 60, // Adjust the width of the image as needed
                height: 60, // Adjust the height of the image as needed
              ),
            const SizedBox(width: 2), // Add spacing between image and text
            Text(
              _selectedCar!.carManufacturer, // Use selected manufacturer name if not null, otherwise empty string
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold),
            ),
          ],
        ),
        )]
        ),
        TableRow(
          children: [
            TableCell(
              child: Text(
                "Year", 
                style: GoogleFonts.poppins(
                  fontSize: 15),)
              ),
              TableCell(
              child: Text(
                "Type", 
                style: GoogleFonts.poppins(
                  fontSize:15))
              ),
              ]
        ),
        TableRow(
          children: [
            TableCell(
              child: Text(
                _selectedCar!.carYear, 
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold),)
              ),
              TableCell(
              child: Text(
                _selectedCar!.carType, 
                style: GoogleFonts.poppins(
                  fontSize:25,
                  fontWeight: FontWeight.bold))
              ),
              ]
        ),
        ],
            ),
          ),
        
            //Information of the car
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditCarScreen(user: widget.user, car: _selectedCar,)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.list,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 70,
                child: Text(
                  "Edit Car Details",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(), // Add Spacer widget to evenly space columns
          Column(
            children: [
              SizedBox(
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InsuranceScreen(user: widget.user, car: _selectedCar,)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.security,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 100,
                child: Text(
                  "Car     Insurance Policy",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(), // Add Spacer widget to evenly space columns
          Column(
            children: [
              SizedBox(
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MaintenanceScreen(user: widget.user, car: _selectedCar,)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(54, 48, 98, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.home_repair_service,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 110,
                child: Text(
                  "Car      Maintenance",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
            ),
          ),
        ),
        
          ],
        );
            },
          ),
        ),
          ],
        ),
            ),
      ),
      
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.push(context,
              MaterialPageRoute(builder: (content)=> AddCarScreen(user: widget.user)));
    },
    tooltip: 'Register Car',
    hoverElevation: 10,
    backgroundColor: const Color.fromRGBO(249, 148, 23, 99),   
    shape: const CircleBorder(),
    child: const Icon(Icons.add,color: Colors.white,),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    
  );}
  
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



}