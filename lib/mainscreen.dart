import 'package:car_buddy/cartabscreen.dart';
import 'package:car_buddy/fueltabscreen.dart';
import 'package:car_buddy/models/car.dart';
import 'package:car_buddy/models/user.dart';
import 'package:car_buddy/profiletabscreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Car";
  List<Car> carList = <Car>[];

  @override
  void initState(){
    super.initState();
    print(widget.user.name);
    tabchildren = [
      CarTabScreen(user: widget.user),
      FuelTabScreen(user: widget.user),
      ProfileTabScreen(user: widget.user)
    ];
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: tabchildren[_currentIndex],
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: onTabTapped,
        color: const Color.fromRGBO(54, 48, 98, 1),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        items: const [
          Icon(
            Icons.directions_car,
            color: Colors.white,
            size: 30,),
          Icon(
            Icons.local_gas_station,
            color: Colors.white,
            size: 30,),
          Icon(
            Icons.person,
            color: Colors.white,
            size: 30,)
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if(_currentIndex == 0) {
        maintitle = "Car";
      }
      if(_currentIndex == 1) {
        maintitle = "Fuel Consumption";
      }
      if(_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }

}