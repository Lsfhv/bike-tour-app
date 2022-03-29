import 'package:http/http.dart';

Future getData(url) async {
  Response response = await get(Uri.parse(url));
  return response.body;
}
