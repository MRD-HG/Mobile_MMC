import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QRCheckPage extends StatefulWidget {
  @override
  _QRCheckPageState createState() => _QRCheckPageState();
}

class _QRCheckPageState extends State<QRCheckPage> {
  String qrResult = "";

  Future<void> verifyQRCode(String qrResult) async {
    final url = Uri.parse(
        'https://fasttealbike95.conveyor.cloud/gateway/EventParticipant/VerifyQRCode');
    final requestBody = {
      "qrResult": qrResult,
      "isParticipated": true,
    };

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar('QR Code verified successfully');
      } else if (response.statusCode == 404) {
        _showErrorSnackBar('QR Code not found');
      } else {
        _showErrorSnackBar(
            'Failed to verify QR Code. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error occurred while verifying QR Code: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Check Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QR Result: $qrResult',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                verifyQRCode(qrResult);
              },
              child: Text('Verify QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
