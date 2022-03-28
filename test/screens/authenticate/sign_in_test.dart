import 'package:bike_tour_app/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'valid_regex.dart';

void main() {
 test('Empty email test', () {
    var emptyInput = ' ';

    var result = ValidRegex().getValidEmailRegExp().hasMatch(emptyInput);

    expect(result, false);
  });

  
  test('Given empty password input', () async {
    var emptyInput = ' ';

    var result = ValidRegex().getValidPasswordRegExp().hasMatch(emptyInput);

    expect(result, false);
  });

  
  test('Given valid email address', () async {
    var result = ValidRegex().getValidEmailRegExp().hasMatch('JohnDoe1@example.com');

    expect(result, true);
  });

  
  test('Given valid Password', () {  
    var result = ValidRegex().getValidPasswordRegExp().hasMatch('Qwerty13!');

    expect(result, true);
  });

  
  test('Given Invalid Email', (){
     var result = ValidRegex().getValidEmailRegExp().hasMatch('JohnDoe1example.com');

    expect(result, false);
  });

  
  test('Given Invalid Password', () {
    var result = ValidRegex().getValidPasswordRegExp().hasMatch('happy');

    expect(result, false);
  });

}
