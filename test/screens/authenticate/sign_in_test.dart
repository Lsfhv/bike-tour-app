import 'package:flutter_test/flutter_test.dart';
import 'package:bike_tour_app/screens/authenticate/sign_in_form.dart';

void main() {
  test('Empty email test', () {
    final result = EmailValidator.validate('');
    expect(result, 'Not a valid email');
  });

  
  test('Given empty password input', (){
    final result = PasswordValidator.validate('');
    expect(result, 'Password must be 8 characters long, contain an Upper Case character, a Number and a Special character');
  });

  
  test('Given valid email address', () {
    final result = EmailValidator.validate('JohnDoe1@example.com');
    expect(result, '');
  });

  
  test('Given valid Password', () {  
    final result = PasswordValidator.validate('Qwerty13!');

    expect(result, '');
  });

  
  test('Given Invalid Email', (){
     final result = EmailValidator.validate('johndoe.com');

    expect(result, 'Not a valid email');
  });

  
  test('Given Invalid Password', () {
    final result = PasswordValidator.validate('happy');

    expect(result,  'Password must be 8 characters long, contain an Upper Case character, a Number and a Special character' );
  });

}
