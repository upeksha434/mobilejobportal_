class AuthUser {
  final int id;
  final String email;
  final String fName;
  final String lName;
  final int roleId;

  AuthUser({required this.id, required this.fName, required this.lName, required this.email, required this.roleId});

  factory AuthUser.fromJSON(Map<String, dynamic> data) {
    return AuthUser(
      id:data['id'],
      roleId: data['roleId'],
      email: data['email'],
      fName: data['fname'],
      lName: data['lname'],
    );
  }

}