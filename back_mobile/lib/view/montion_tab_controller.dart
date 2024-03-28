import 'package:back_mobile/controllers/bottom_navigation_controller.dart';
import 'package:back_mobile/view/Admin/Qr_scanner.dart';
import 'package:back_mobile/view/Admin/mainAdmin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
class MontionTabBarPage extends StatelessWidget {
   MontionTabBarPage({super.key});
     BottomNavigationController bottomNavigationController=Get.put(BottomNavigationController());
    final screens =[MainPage(),QR_Scan()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(() => IndexedStack(
      index: bottomNavigationController.selectedIndex.value,
      children: screens,
      
    ))
      ,
      bottomNavigationBar:MotionTabBar(
        initialSelectedTab: "Acceuil",
         labels:["Acceuil","Scan"], 
         tabIconColor: Color(0xFFC83A31),
         icons: [Icons.home_filled,Icons.qr_code_scanner_outlined],
         tabSize: 80,
         tabSelectedColor:Color.fromARGB(255, 199, 47, 37) ,
         textStyle: TextStyle(color: Color.fromARGB(255, 183, 34, 23)),
         onTabItemSelected: (index){
          bottomNavigationController.selectedIndex(index);
         },
         ) ,
    );
  }
}
