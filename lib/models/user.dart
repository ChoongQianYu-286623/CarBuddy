class User {
  String? id;
  String? name;
  String? email;
  String? ic;
  String? phone;
  String? password;
  String? datereg;
  String? otp;

  User(
      {this.id,
      this.name,
      this.email,
      this.ic,
      this.phone,
      this.password,
      this.datereg,
      this.otp});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    ic = json['ic'];
    phone = json['phone'];
    password = json['password'];
    datereg = json['datereg'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['ic'] = this.ic;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['datereg'] = this.datereg;
    data['otp'] = this.otp;
    return data;
  }
}
