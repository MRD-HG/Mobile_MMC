import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../controllers/Constant.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String urlC = Constant.apiUrl;
  int participantCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Barcode Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

 void _onQRViewCreated(QRViewController controller) {
  this.controller = controller;
  controller.scannedDataStream.listen((scanData) async {
   
    // controller.pauseCamera();

  
    List<String> values = scanData.code!.split('#');
    if (values.length == 2) {
      String idParticipant = values[0];
      String idEvent = values[1];
      await verifyQRCode(idParticipant, idEvent);
    }

    
    await Future.delayed(Duration(seconds: 2));
    controller.resumeCamera();
  });
}
 
Future<void> fetchParticipantData() async {
  final response = await http.get(Uri.parse('$urlC/Participant/'));
  if(response.statusCode ==200){
    List<dynamic> participantData = jsonDecode((response.body));
    setState(() {
      participantCount= participantData.length;
    });
    
  }
  else{
      throw Exception('Failed to load Participant Data');
    }
}

 Future<void> verifyQRCode(String idParticipant, String idEvent) async {
  print("$idEvent + $idParticipant");
    String apiUrl = '$urlC/EventParticipant/VerifyQRCode';
    Map<String, dynamic> requestPayload = {
      'id_Participant': idParticipant,
      'id_Event': idEvent,
      'isParticipated': true,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Verification Successful', backgroundColor: Colors.green);
      } else {
        Fluttertoast.showToast(
          msg: 'Verification Failed: ${response.statusCode}',
          backgroundColor: Colors.red,
        );
        print('Error: ${response.body}');  
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e', backgroundColor: Colors.red);
      print('Exception: $e');  
    }
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
