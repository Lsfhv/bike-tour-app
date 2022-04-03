import 'package:http/http.dart';

getData(url) async {
  Response response = await get(Uri.parse(url));
  return response.body;
}
