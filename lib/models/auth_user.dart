class AuthUser {
  final int id;
  final String email;
  final String fName;
  final String lName;

  AuthUser({required this.id, required this.fName, required this.lName, required this.email});

  factory AuthUser.fromJSON(Map<String, dynamic> data) {
    return AuthUser(
      id:data['id'],
      email: data['email'],
      fName: data['fname'],
      lName: data['lname'],
    );
  }

}