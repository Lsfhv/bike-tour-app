import 'package:flutter_test/flutter_test.dart';
import 'package:bike_tour_app/screens/authenticate/forgot_password_form.dart';


import 'valid_regex.dart';

void main() {


  test('Empty email test', () {
    
    final result = ValidRegex().getValidEmailRegExp().hasMatch(' ');

    expect(result, false);
  });

  test('Given invalid Email', () {
    final result = ValidRegex().getValidEmailRegExp().hasMatch('johnDoe@outlook');

    expect(result, false);
  });

  test('Given valid Email', () {
    final result = ValidRegex().getValidEmailRegExp().hasMatch('johnDoe@outlook.com');

    expect(result, false);
  });

}
