import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:back_mobile/controllers/Constant.dart';

class QRCheckPage extends StatefulWidget {
  @override
  _QRCheckPageState createState() => _QRCheckPageState();
}

class _QRCheckPageState extends State<QRCheckPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String urlC = Constant.apiUrl;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      verifyQRCode(scanData.code);
    });
  }

  Future<void> verifyQRCode(String? qrResult) async {
    if (qrResult == null) {
      _showErrorSnackBar('No QR Code detected');
      return;
    }

    List<String> qrParts = qrResult.split('#');
    if (qrParts.length != 2) {
      _showErrorSnackBar('Invalid QR Code format');
      return;
    }
    String idEvent = qrParts[0];
    String idParticipant = qrParts[1];

    final url = Uri.parse('$urlC/EventParticipant/VerifyQRCode');
    final requestBody = {
      "id_Participant": idParticipant,
      "id_Event": idEvent,
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
        _showSuccessSnackBar('Participant verified successfully');
      } else if (response.statusCode == 404) {
        _showErrorSnackBar('Participant not found');
      } else {
        _showErrorSnackBar(
            'Failed to verify Participant. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error occurred while verifying Participant: $e');
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
