import 'package:http/http.dart' as http;

class GetApi {
  void generateBikePoints(List<String> postcodes) {}

  Future<http.Response> fetchBikePoints() {
    return http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
  }
}

// void main() {
//   var x = GetApi();
//   print(jsonDecode(x.fetchBikePoints()));
// }
