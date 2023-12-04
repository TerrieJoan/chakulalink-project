class UserModel {
  String id;
  String fullName;
  String email;
  String phoneNumber;
  String location;
  int role;
  String createdBy;
  String createdDate;
  String? updatedBy;
  String? updatedDate;
  String? password;
  String? userName;
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.role,
    required this.createdBy,
    required this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.password,
    this.userName,
  });
}
