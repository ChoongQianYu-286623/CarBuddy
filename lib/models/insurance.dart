class Insurance {
  late int carId;
  late int userId;
  late String insuranceName;
  late String policyNumber;
  late String startDate;
  late String endDate;

  Insurance(
      {required this.carId,
      required this.userId,
      required this.insuranceName,
      required this.policyNumber,
      required this.startDate,
      required this.endDate});

  Insurance.fromJson(Map<String, dynamic> json) {
    carId = json['car_id'];
    userId = json['user_id'];
    insuranceName = json['insurance_name'];
    policyNumber = json['policy_number'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_id'] = this.carId;
    data['user_id'] = this.userId;
    data['insurance_name'] = this.insuranceName;
    data['policy_number'] = this.policyNumber;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}