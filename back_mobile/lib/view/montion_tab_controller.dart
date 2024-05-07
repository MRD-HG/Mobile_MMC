import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

import 'Admin/Qr_scanner.dart';
import 'Admin/mainAdmin.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }
}

class MontionTabBarPage extends StatelessWidget {
  final BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());
  final List<Widget> screens = [MainPage(), QRCodeScanner()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: bottomNavigationController.selectedIndex.value,
        children: screens,
      )),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Acceuil",
        labels: ["Acceuil", "Scan"],
        tabIconColor: Color(0xFFC83A31),
        icons: [Icons.home_filled, Icons.qr_code_scanner_outlined],
        tabSize: 80,
        tabSelectedColor: Color.fromARGB(255, 199, 47, 37),
        textStyle: TextStyle(color: Color.fromARGB(255, 183, 34, 23)),
        onTabItemSelected: (index) {
          bottomNavigationController.selectTab(index);
        },
      ),
    );
  }
}
