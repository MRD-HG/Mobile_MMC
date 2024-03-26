import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScanPage(),
    );
  }
}

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image(image: AssetImage("assets/images/logo-only.png")),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[50],
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.event,
                        size: 50,
                        color: Color(0xFF74b2da),
                      ),
                      Text(
                        "Events",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "0",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.alarm,
                        size: 50,
                        color: Color(0xFFeebc54),
                      ),
                      Text(
                        "Sessions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "0",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 50,
                        color: Color(0xFFc83a31),
                      ),
                      Text(
                        "City",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "0",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(8),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.groups_2,
                        size: 50,
                        color: Color(0xFFa5ca6d),
                      ),
                      Text(
                        "Participant",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "0",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Up comming Event"),
                SizedBox(height: 10),
                EventDetailCard(
                  date: "12/14",
                  eventName: "Flutter Conference",
                  places: 100,
                  local:"Rabat" ,
                ), 
                EventDetailCard(
                  date: "04/15",
                  eventName: "AI",
                  places: 100,
                  local:"Tanger"
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class EventDetailCard extends StatelessWidget {
  final String date;
  final String eventName;
  final int places;
  final String local;

  const EventDetailCard({
    Key? key,
    required this.date,
    required this.eventName,
    required this.places,
    required this.local,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$eventName',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$local',
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Available Places: $places',
                      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
