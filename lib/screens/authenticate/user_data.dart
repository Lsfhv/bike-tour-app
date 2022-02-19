class UserData {
  final firstName;
  final lastName;
  final email;

  UserData(this.firstName, this.lastName, this.email);

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };
}
