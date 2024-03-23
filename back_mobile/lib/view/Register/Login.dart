import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(" Log In "),
        ),
        body: Row(
          children: [
            Container(
              child:
                  // ignore: prefer_const_constructors
                  Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Image(
                        image: AssetImage("assets/images/logo-only.png"),
                        width: 100,
                        height: 100,
                      ),
                      //adding a new design in right side color:#c83a31
                      Expanded(
                          child: Container(
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFC83A31),
                                  Color.fromARGB(255, 204, 75, 65),
                                  Color.fromARGB(255, 199, 93, 85),


                                
                                ])),
                      ))
                    ]),
              ),
            ),
            Column(
              children: [
                const Text("Name"),
                TextField(
                  controller: nameController,
                ),
                 const Text("Password"),
                TextField(
                  controller: passwordController,
                ),
               const SizedBox(height: 10),
               ElevatedButton(
                onPressed: ()=>({}), 
                child: Text("LogIn"),
                style: ButtonStyle(
                  
                ),
               
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}
