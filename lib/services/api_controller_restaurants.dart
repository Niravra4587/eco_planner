import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/POI_model.dart';


Future<PoiResponse> fetchrestaurantdata() async {
  final response = await http.get(Uri.parse('https://api.tomtom.com/search/2/nearbySearch/.json?lat=37.337&lon=-121.89&radius=10000&categorySet=7315&view=IN&relatedPois=off&key=AuCpuHKc6CfIarUsu2HSYnzPNmFQv7iX')); // Replace with your API URL.

  if (response.statusCode == 200) {
    print(response);
    return PoiResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load restaurant data');
  }
}
