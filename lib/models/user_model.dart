// a trivial userdata class to work with user data locally and convert to json
// for ez upload to firebase

class UserData {
  final _firstName;
  final _lastName;
  final _email;

  UserData(this._firstName, this._lastName, this._email);

  Map<String, dynamic> toJson() => {
        'firstName': _firstName,
        'lastName': _lastName,
        'email': _email,
      };
}
