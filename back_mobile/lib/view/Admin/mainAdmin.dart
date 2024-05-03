import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:back_mobile/controllers/Constant.dart';

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
  String url = Constant.apiUrl;

  @override
  void initState() {
    super.initState();
    fetchEventData();
    fetchParticipantData();
    fetchSessionData();
    fetchCityData();
    fetchLatestEventData();
  }

  Future<void> fetchEventData() async {
    final response = await http.get(Uri.parse('$url/event'));
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
    final response = await http.get(Uri.parse('$url/participant'));
    if (response.statusCode == 200) {
      List<dynamic> participantData = jsonDecode(response.body);
      setState(() {
        participantCount = participantData.length;
      });
    } else {
      throw Exception('Failed to load participant data');
    }
  }

  Future<void> fetchSessionData() async {
    final response = await http.get(Uri.parse('$url/session'));
    if (response.statusCode == 200) {
      List<dynamic> sessionData = jsonDecode(response.body);
      setState(() {
        sessionCount = sessionData.length;
      });
    } else {
      throw Exception('Failed to load session data');
    }
  }

  Future<void> fetchCityData() async {
    final response = await http.get(Uri.parse('$url/city'));
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
    final response = await http.get(Uri.parse('$url/event'));
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

  Future<List<dynamic>> fetchAllEvents() async {
    final response = await http.get(Uri.parse('$url/event'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load event data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo-only.png',
            height: width * 0.1,
            width: width * 0.1,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: buildCounterCard(title: 'Events', count: eventCount),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: buildCounterCard(title: 'Participants', count: participantCount),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: buildCounterCard(title: 'Sessions', count: sessionCount),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: buildCounterCard(title: 'Cities', count: cityCount),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'All Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: fetchAllEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dynamic> events = snapshot.data ?? [];
                  return Column(
                    children: events.map((event) => buildEventCard(event)).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCounterCard({required String title, required int count}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Material(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  count.toString(),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEventCard(Map<String, dynamic> event) {
    return FadeInEventCard(
      delay: 500, // delay in milliseconds
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(event: event),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Hero(
            tag: event['id'],
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Address: ${event['address']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Start Date: ${event['startDate']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'End Date: ${event['endDate']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        event['imagePath'],
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: event['id'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  event['imagePath'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              event['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${event['address']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Start Date: ${event['startDate']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'End Date: ${event['endDate']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class FadeInEventCard extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeInEventCard({Key? key, required this.child, this.delay = 500}) : super(key: key);

  @override
  _FadeInEventCardState createState() => _FadeInEventCardState();
}

class _FadeInEventCardState extends State<FadeInEventCard> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: widget.delay),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller!);
    controller?.forward();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: widget.child,
    );
  }
}
