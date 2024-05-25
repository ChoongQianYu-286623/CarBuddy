class Maintenance {
  late String carId;
  late String userId;
  late String maintenanceId;
  late String maintenanceDate;
  late String maintenanceType;
  late String maintenanceWorkshop;
  late String maintenanceLocation;
  late String maintenanceState;

  Maintenance(
      {required this.carId,
      required this.userId,
      required this.maintenanceId,
      required this.maintenanceDate,
      required this.maintenanceType,
      required this.maintenanceWorkshop,
      required this.maintenanceLocation,
      required this.maintenanceState});

  Maintenance.fromJson(Map<String, dynamic> json) {
    carId = json['car_id'];
    userId = json['user_id'];
    maintenanceId = json['maintenance_id'];
    maintenanceDate = json['maintenance_date'];
    maintenanceType = json['maintenance_type'];
    maintenanceWorkshop = json['maintenance_workshop'];
    maintenanceLocation = json['maintenance_location'];
    maintenanceState = json['maintenance_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_id'] = this.carId;
    data['user_id'] = this.userId;
    data['maintenance_id'] = this.maintenanceId;
    data['maintenance_date'] = this.maintenanceDate;
    data['maintenance_type'] = this.maintenanceType;
    data['maintenance_workshop'] = this.maintenanceWorkshop;
    data['maintenance_location'] = this.maintenanceLocation;
    data['maintenance_state'] = this.maintenanceState;
    return data;
  }
}