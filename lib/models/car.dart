class Car {
  late int carId;
  late String userId;
  late String carName;
  late String carModel;
  late String carManufacturer;
  late String carYear;
  late String carType;
  late String carFuelType;
  late String carTank;

  Car(
      {required this.carId,
      required this.userId,
      required this.carName,
      required this.carModel,
      required this.carManufacturer,
      required this.carYear,
      required this.carType,
      required this.carFuelType,
      required this.carTank});

  Car.fromJson(Map<String, dynamic> json) {
    carId = json['car_id'];
    userId = json['user_id'];
    carName = json['car_name'];
    carModel = json['car_model'];
    carManufacturer = json['car_manufacturer'];
    carYear = json['car_year'];
    carType = json['car_type'];
    carFuelType = json['car_fuelType'];
    carTank = json['car_tank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_id'] = this.carId;
    data['user_id'] = this.userId;
    data['car_name'] = this.carName;
    data['car_model'] = this.carModel;
    data['car_manufacturer'] = this.carManufacturer;
    data['car_year'] = this.carYear;
    data['car_type'] = this.carType;
    data['car_fuelType'] = this.carFuelType;
    data['car_tank'] = this.carTank;
    return data;
  }
}