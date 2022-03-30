import 'package:flutter_test/flutter_test.dart';
import 'package:bike_tour_app/screens/authenticate/forgot_password_form.dart';

void main() {
 
  test('Empty email test', () {
    final result = EmailFieldValidator.validate('');

    expect(result, 'Not a valid email');
  });

  test('Given invalid Email', () {
    final result = EmailFieldValidator.validate('johnDoe@outlook');

    expect(result, 'Not a valid email');
  });

  test('Given valid Email', () {
    final result = EmailFieldValidator.validate('johnDoe@outlook.com');

    expect(result, '');
  });

}
