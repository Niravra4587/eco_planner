import 'package:eco_planner/screens/DetailScreen.dart';
import 'package:eco_planner/services/api_controller_restaurants.dart';
import 'package:flutter/material.dart';

import '../custom/CustomListTile.dart';
import '../model/POI_model.dart';
import '../services/api_controller.dart';
class restaurant extends StatefulWidget {
  const restaurant({Key? key}) : super(key: key);

  @override
  State<restaurant> createState() => _restaurantState();
}

class _restaurantState extends State<restaurant> {


  late Future<PoiResponse> futurePoiResponse;

  @override
  void initState() {
    super.initState();
    futurePoiResponse = fetchrestaurantdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap with SingleChildScrollView if needed
        child: FutureBuilder<PoiResponse>(
          future: futurePoiResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final pois = snapshot.data!.results;

              return Column(
                children: pois.map((poi) {

                  return CustomListTile(
                    title: poi.name,
                    address: poi.address,
                    // trailing: Text('${poi.lat}, ${poi.lon}'),
                    onTap:(){
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => MapWithRoutes(

                            endLat: poi.lat,
                            endLon: poi.lon,
                          ),
                        ),
                      );
                    }, icon: Icons.energy_savings_leaf_sharp,
                  );
                }).toList(),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}