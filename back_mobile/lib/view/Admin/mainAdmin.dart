import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatelessWidget {
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
  int eventCount = 0;
  int participantCount = 0;
  int sessionCount = 0;
  int cityCount = 0;
  List<String> cities = [];
  Map<String, dynamic> latestEvent = {};

  @override
  void initState() {
    super.initState();
    fetchEventData();
    fetchParticipantData();
    fetchCityData();
    fetchLatestEventData();
  }

  Future<void> fetchEventData() async {
    final response = await http.get(Uri.parse('https://fasttealbike95.conveyor.cloud/gateway/event'));

    if (response.statusCode == 200) {
      List<dynamic> eventData = jsonDecode(response.body);
      setState(() {
        eventCount = eventData.length;
      });
    } else {
      throw Exception('Failed to load event data');
    }
  }

  Future<void> fetchParticipantData() async {
    final response = await http.get(Uri.parse('https://fasttealbike95.conveyor.cloud/gateway/participant'));

    if (response.statusCode == 200) {
      List<dynamic> participantData = jsonDecode(response.body);
      setState(() {
        participantCount = participantData.length;
      });
    } else {
      throw Exception('Failed to load participant data');
    }
  }

  Future<void> fetchCityData() async {
    final response = await http.get(Uri.parse('https://fasttealbike95.conveyor.cloud/gateway/city'));

    if (response.statusCode == 200) {
      List<dynamic> cityData = jsonDecode(response.body);
      setState(() {
        cityCount = cityData.length;
        cities = cityData.map((city) => city['name'] as String).toList();
      });
    } else {
      throw Exception('Failed to load city data');
    }
  }

  Future<void> fetchLatestEventData() async {
    final response = await http.get(Uri.parse('https://fasttealbike95.conveyor.cloud/gateway/event'));

    if (response.statusCode == 200) {
      List<dynamic> eventData = jsonDecode(response.body);
      if (eventData.isNotEmpty) {
        setState(() {
          latestEvent = eventData.last;
        });
      }
    } else {
      throw Exception('Failed to load latest event data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo-only.png',
                height: 40,
                width: 40,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event count
              Text('Events: $eventCount'),
              SizedBox(height: 10),
              // Participant count
              Text('Participants: $participantCount'),
              SizedBox(height: 10),
              // Session count
              Text('Sessions: $sessionCount'),
              SizedBox(height: 10),
              // City count
              Text('Cities: $cityCount'),
              SizedBox(height: 10),
              // Cities list
              Text('City Names:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cities.map((city) => Text(city)).toList(),
              ),
              SizedBox(height: 20),
              // Latest event details
              Text('Latest Event:'),
              SizedBox(height: 5),
              if (latestEvent.isNotEmpty)
                EventDetailCard(
                  eventName: latestEvent['name'],
                  date: latestEvent['date'],
                  places: latestEvent['places'],
                  local: latestEvent['local'],
                )
              else
                Text('No events available'),
            ],
          ),
        ),
      ),
    );
  }
}

class EventDetailCard extends StatelessWidget {
  final String? date;
  final String? eventName;
  final int? places;
  final String? local;

  const EventDetailCard({
    Key? key,
    this.date,
    this.eventName,
    this.places,
    this.local,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 5),
                    Text(
                      local ?? '',
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Date: $date',
                      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Available Places: $places',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
