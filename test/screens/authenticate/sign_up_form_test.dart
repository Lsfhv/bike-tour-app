import 'package:bike_tour_app/screens/authenticate/sign_up_form.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets("Test email is valid", (WidgetTester tester) async {
    final emailField = find.byKey(const Key("EmailField"));
    final signUpContainer = find.text('Register');

    await tester.pumpWidget(const SignUpForm());

    await tester.enterText(emailField, "T");
    await tester.tap(signUpContainer);
    await tester.pump();

    expect(find.text("T"), 'Not a valid email');
  });
}
