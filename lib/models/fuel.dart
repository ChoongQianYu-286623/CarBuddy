class Fuel {
  late int carId;
  late int userId;
  late String fuelDate;
  late String fuelCost;
  late String fuelVolume;
  late String fuelType;
  late String fuelMileage;
  late String fuelCompany;
  late String fuelLocation;
  late String fuelState;

  Fuel(
      {required this.carId,
      required this.userId,
      required this.fuelDate,
      required this.fuelCost,
      required this.fuelVolume,
      required this.fuelType,
      required this.fuelMileage,
      required this.fuelCompany,
      required this.fuelLocation,
      required this.fuelState});

  Fuel.fromJson(Map<String, dynamic> json) {
    carId = json['car_id'];
    userId = json['user_id'];
    fuelDate = json['fuel_date'];
    fuelCost = json['fuel_cost'];
    fuelVolume = json['fuel_volume'];
    fuelType = json['fuel_type'];
    fuelMileage = json['fuel_mileage'];
    fuelCompany = json['fuel_company'];
    fuelLocation = json['fuel_location'];
    fuelState = json['fuel_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_id'] = this.carId;
    data['user_id'] = this.userId;
    data['fuel_date'] = this.fuelDate;
    data['fuel_cost'] = this.fuelCost;
    data['fuel_volume'] = this.fuelVolume;
    data['fuel_type'] = this.fuelType;
    data['fuel_mileage'] = this.fuelMileage;
    data['fuel_company'] = this.fuelCompany;
    data['fuel_location'] = this.fuelLocation;
    data['fuel_state'] = this.fuelState;
    return data;
  }
}