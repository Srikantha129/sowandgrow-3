class User {
  final String username;
  final String password;
  final String userrole;
  final String farmingarea;
  final String farmingtype;
  final String status;
  final String nic;
  final String isfarming;

  User({
    required this.username,
    required this.password,
    required this.userrole,
    required this.farmingarea,
    required this.farmingtype,
    required this.status,
    required this.nic,
    required this.isfarming,
  });

  String get getUsername => username;
  String get getPassword => password;
  String get getUserrole => userrole;
  String get getFarmingarea => farmingarea;
  String get getFarmingtype => farmingtype;
  String get getStatus => status;
  String get getNic => nic;
  String get getIsfarming => isfarming;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? 'Unknown',
      password: map['password'] ?? '',
      userrole: map['userrole'] ?? 'unknown',
      farmingarea: map['farmingarea'] ?? 'Not Specified',
      farmingtype: map['farmingtype'] ?? 'Not Specified',
      status: map['status'] ?? 'inactive',
      nic: map['nic'] ?? 'Unknown',
      isfarming: map['isfarming'] ?? 'false',
    );
  }
}
