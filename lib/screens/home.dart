import 'package:eco_planner/screens/profile.dart';
import 'package:eco_planner/screens/restaurants.dart';
import 'package:eco_planner/screens/tourist_spots.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/sustainable.png"),
                  ),
                ),
              ),
              const Text(
                "Eco-Planner",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.black26,
                  size: 25,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(icon: Icon(Icons.place_sharp), text: 'Tourist Attractions'),
              Tab(icon: Icon(Icons.restaurant), text: 'Restaurants'),
              Tab(icon: Icon(Icons.insert_chart_outlined), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [


            Tourist(),
            restaurant(),
            profile(),
            /*Center(child: Text('Calendar Screen')),
            Center(child: Text('Profile Screen')),*/
          ],
        ),
      )
    );
  }
}
