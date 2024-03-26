import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QR_Scan extends StatefulWidget {
  const QR_Scan({super.key});

  @override
  State<QR_Scan> createState() => _QR_ScanState();
}

class _QR_ScanState extends State<QR_Scan> {
   String qrResult="";
  Future<void>ScanQR()async{
  try{
    final qrcode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    if(!mounted)return;
      setState(() {
        this.qrResult= qrcode.toString();
      });

  }on PlatformException{
    Icon(Icons.error);
    qrResult = "Fail to Read QR Code";
  }
  
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(
           width: 200,
            height: 200,
          child:  Image(
            image: AssetImage("assets/images/logo-only.png"),
           width: 100,
            height: 100,
            fit: BoxFit.fill,),
        )
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
              label:Center(child: Text("Scan The Code")),
              icon: Icon(Icons.qr_code_scanner_rounded),
              onPressed: ()=>{}, 
              
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(qrResult,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    ElevatedButton.icon(
                      onPressed: ScanQR,
                    icon: const Icon(Icons.qr_code_2_outlined),
                    label:Text("Scan QR_Code") ,
                    
                      )
                  ],
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}
