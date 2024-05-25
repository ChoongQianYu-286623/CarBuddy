import 'dart:convert';
import 'package:car_buddy/addfuelscreen.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/models/fuel.dart';
import 'package:car_buddy/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

class FuelTabScreen extends StatefulWidget {
  final User user;
  // final Car? car;
  const FuelTabScreen({super.key, required this.user});

  @override
  State<FuelTabScreen> createState() => _FuelTabScreenState();
}

class _FuelTabScreenState extends State<FuelTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Fuel";
  late double screenHeight,screenWidth, cardwidth;
  Car? _selectedCar;
  List<Car> carList = <Car>[];
  String _selectedHistory = "History";
  DateTime today = DateTime.now();
  List<Fuel> fuelList = <Fuel>[];
  Map<DateTime, List<Fuel>> fuels = {};
  DateTime? _selectedDay;
  late List<Fuel> filteredFuelList = [];
  late List<FlSpot> flSpots;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

final List<String> monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

List<int> showingTooltipOnSpots = [];


  @override
  void initState(){
    super.initState();
    _loadCars();
    _loadFuel();
    _selectedDay = _selectedDay ;
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
        title: Text("Fuel Consumption",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white
          ))),
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
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
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
                      child: Text(
                        car.carName,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 230),
                  ],
                ),
              );
            }).toList(),
            iconSize: 40,
            elevation: 16,
            underline: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(245, 245, 245, 1),
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedHistory == "History"
                                  ? const Color.fromRGBO(54, 48, 98, 1)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedHistory = "History";
                            });
                          },
                          child: Text(
                            'History',
                            style: GoogleFonts.poppins(
                              color: _selectedHistory == "History"
                                  ? const Color.fromRGBO(54, 48, 98, 1)
                                  : Colors.grey,
                              fontSize: 20,
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
                              color: _selectedHistory == "Fuel Consumptions"
                                  ? const Color.fromRGBO(54, 48, 98, 1)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedHistory = "Fuel Consumptions";
                            });
                          },
                          child: Text(
                            'Fuel Consumptions',
                            style: GoogleFonts.poppins(
                              color: _selectedHistory == "Fuel Consumptions"
                                  ? const Color.fromRGBO(54, 48, 98, 1)
                                  : Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      Expanded(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _selectedHistory == "Fuel Consumptions"
              ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center( //graphy display
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [ 
                          // Dropdown button for selecting month
DropdownButton<int>(
  value: selectedMonth,
  onChanged: (int? month) {
    if (month != null) {
      _selectMonth(month);
    }
  },
  items: List.generate(12, (index) {
    return DropdownMenuItem<int>(
      value: index + 1,
      child: Text(monthNames[index]),
    );
  }),
),

// Dropdown button for selecting year
DropdownButton<int>(
  value: selectedYear,
  onChanged: (int? year) {
    if (year != null) {
      _selectYear(year);
    }
  },
  items: List.generate(10, (index) {
    return DropdownMenuItem<int>(
      value: DateTime.now().year - index,
      child: Text('${DateTime.now().year - index}'),
    );
  }),
),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: screenHeight*0.40,
                          child: LineChart(
  LineChartData(
    lineTouchData: LineTouchData(
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return const TouchedSpotIndicatorData(
            FlLine(color: Colors.blue, strokeWidth: 2),
            FlDotData(show: true),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        // tooltipBgColor: Colors.blueAccent,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            return LineTooltipItem(
              touchedSpot.y.toStringAsFixed(2),
              textStyle,
            );
          }).toList();
        },
      ),
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        if (!event.isInterestedForInteractions || touchResponse == null || touchResponse.lineBarSpots == null) {
          setState(() {
            showingTooltipOnSpots = [];
          });
          return;
        }

        setState(() {
          showingTooltipOnSpots = touchResponse.lineBarSpots!.map((spot) {
            return spot.spotIndex;
          }).toList();
        });
      },
    ),
    minX: 1,
    minY: 0,
    maxY: 10,
    borderData: FlBorderData(
      show: true,
      border: const Border(
        top: BorderSide(color: Color.fromRGBO(245, 245, 245, 1),),
        left: BorderSide(color: Colors.black87),
        right: BorderSide(color: Color.fromRGBO(245, 245, 245, 1),),
        bottom: BorderSide(color: Colors.black87),
      ),
    ),
    titlesData: const FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: Text("Fuel Consumptions (ℓ/km)"),
        sideTitles: SideTitles(
          reservedSize: 30,
          interval: 1.0,
          showTitles: true,
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: Text("Dates"),
        sideTitles: SideTitles(
          reservedSize: 30,
          interval: 1,
          showTitles: true,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    ),
    gridData: const FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
    ),
    lineBarsData: [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        isCurved: true,
        color: const Color.fromRGBO(249, 148, 23, 1),
        spots: updateChartData(),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ],
  ),
)

                        ),
                      ),
                      Text(
                        "**Fuel Consumptions: To calculate amount of fuel a car consumes to go a specific distance",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic
                        ),),
                    ],
                  ),
                  ),
              )
              : Column( //fuel history
                  children: [
                    Center(
  child: TableCalendar(
  rowHeight: 35,
  headerStyle: const HeaderStyle(
    formatButtonVisible: false,
    titleCentered: true,
  ),
  availableGestures: AvailableGestures.all,
  selectedDayPredicate: (day) => isSameDay(day, today),
  eventLoader: _getEventsForDay,
  calendarStyle: const CalendarStyle(
    isTodayHighlighted: true,
    todayDecoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    ),
    markerDecoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Color.fromRGBO(76, 77, 125, 70),
    ),
  ),
  firstDay: DateTime.utc(2010, 1, 1),
  lastDay: DateTime.utc(2040, 12, 31),
  focusedDay: today,
  onDaySelected: _onDaySelected,
  calendarBuilders: CalendarBuilders(
    markerBuilder: (context, date, events) {
      if (events.isNotEmpty) {
        double totalCost = events.fold(0, (sum, event) {
          if (event is Fuel) {
            return sum + double.parse(event.fuelCost);
          }
          return sum;
        });

        return Positioned(
          bottom: -10,
          child: Container(
            padding: const EdgeInsets.all(2),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                totalCost.toStringAsFixed(2),
                style: const TextStyle(            
                  color: Color.fromRGBO(77, 76, 125, 50),
                  fontSize: 12
                ),
              ),
            ),
          ),
        );
      }
      return null;
    },
  ),
)

),
// Display filtered fuel data
        if (fuelList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
              height: screenHeight*0.2,
              child: ListView.builder(
                shrinkWrap: true, // Adjust height as needed
                itemCount: fuelList.length,
                itemBuilder: (context, index) {
                  final fuel = fuelList[index];
                  // Display fuel data from each Fuel object (e.g., fuel quantity, station, etc.)
                  if (fuel.carId == _selectedCar?.carId) {
                    return SizedBox(
                      // height: screenHeight*0.35,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "RM ${fuel.fuelCost}",
                                style: GoogleFonts.poppins(
                                  color: const Color.fromRGBO(54, 48, 98, 1),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                fuel.fuelCompany,
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
                              SizedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      fuel.fuelDate,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    Text(
                                      fuel.fuelLocation,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      ", ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      fuel.fuelState,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
                  ],
                ),
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
          builder: (context) => AddFuelScreen(user: widget.user, car: _selectedCar),
        ),
      );
    } else {
    }
    },
    tooltip: 'Add Maintenance',
    hoverElevation: 10,
    backgroundColor: const Color.fromRGBO(249, 148, 23, 50),   
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
            print(carList.first.carName);
          });
        }
      }
    });
}

void _loadFuel() {
      http.post(Uri.parse("${MyConfig().SERVER}/carBuddy/php/load_fuel.php"),
    body: {
      "user_id" : widget.user.id.toString(), // Ensure user_id is converted to String
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if(jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          var fuelData = extractdata as List; // Cast extractdata to List
          List<Fuel> fuel = fuelData.map((fuelJson) => Fuel.fromJson(fuelJson)).toList();
          setState(() {
            fuelList = fuel;
            flSpots = updateChartData();
          });
        }
      }
    });
}

void _onDaySelected(DateTime day, DateTime focusedDay) {
  if (!isSameDay(_selectedDay, day)) {
    setState(() {
      _selectedDay = day;
      today = focusedDay;

      final formattedDay = day.toIso8601String().split('T')[0]; // Format day as YYYY-MM-DD

      fuelList = fuelList.where((fuel) => fuel.fuelDate == formattedDay).toList();
    });
  }
}

List<Fuel> _getEventsForDay(DateTime selectedDay) {
  // Filter the fuelList to get only the events that match the selected day
  List<Fuel> filteredFuelList = fuelList.where((fuel) {
    DateTime fuelDateTime = _parseDateString(fuel.fuelDate);
    return isSameDay(fuelDateTime, selectedDay);
  }).toList();

  return filteredFuelList;
}

DateTime _parseDateString(String dateString) {
  List<String> parts = dateString.split('-');
  int year = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int day = int.parse(parts[2]);
  return DateTime(year, month, day);
}

// Assuming you have a List<Fuel> called fuelList with fuel consumption data

// Modify the updateChartData method to filter data based on selected month and year
List<FlSpot> updateChartData() {
  List<FlSpot> spots = [];
  for (int i = 1; i < fuelList.length; i++) {
    Fuel currentFuel = fuelList[i];
    Fuel previousFuel = fuelList[i - 1];
    double currentMileage = double.parse(currentFuel.fuelMileage);
    double previousMileage = double.parse(previousFuel.fuelMileage);
    
    DateTime currentDate = _parseDateString(currentFuel.fuelDate);
    
    // Check if the current date matches the selected month and year
    if (currentDate.month == selectedMonth && currentDate.year == selectedYear) {
      DateTime previousDate = _parseDateString(previousFuel.fuelDate);
      int daysDifference = currentDate.difference(previousDate).inDays;
      if (daysDifference > 0 && currentMileage > previousMileage) {
        double distanceTraveled = currentMileage - previousMileage;
        double fuelConsumption = double.parse(currentFuel.fuelVolume) / distanceTraveled * 100;
        spots.add(FlSpot(currentDate.day.toDouble(), fuelConsumption));
      }
    }
  }
  return spots;
}

// Method to handle the selection of month
void _selectMonth(int month) {
  setState(() {
    selectedMonth = month;
  });
  // Add logic here to filter the graph data based on the selected month
}

// Method to handle the selection of year
void _selectYear(int year) {
  setState(() {
    selectedYear = year;
  });
  // Add logic here to filter the graph data based on the selected year
}

  
}