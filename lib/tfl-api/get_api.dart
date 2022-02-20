import 'dart:convert';

import 'package:bike_tour_app/models/bike_point_model.dart';
import 'package:http/http.dart' as http;

class GetApi {
  GetApi() {
    (fetchBikePoints());
  }

  Future<List<BikePointModel>> fetchBikePoints() async {
    // Stopwatch stopwatch = Stopwatch()..start();
    List<BikePointModel> bikePoints = [];
    var response =
        await http.get(Uri.parse('https://api.tfl.gov.uk/BikePoint/'));
    var json = jsonDecode(response.body);
    for (int i = 0; i < json.length; i++) {
      bikePoints.add(BikePointModel.fromJson(json[i]));
    }
    // print('executed in ${stopwatch.elapsed}');

    return bikePoints;
  }
}
