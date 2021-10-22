import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junebank/tab/accounttab.dart';
import 'package:junebank/tab/mobiletab.dart';
import 'package:junebank/tab/paytab.dart';
import 'package:junebank/tab/transfertab.dart';
import 'package:local_auth/local_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometric;
  String autherized = "not Autherized";

  // Future<void> _checkBiometric() async {
  //   bool canCheckBiometric;
  //   try {
  //     canCheckBiometric = await auth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _canCheckBiometric = canCheckBiometric;
  //   });
  // } 6/6/2021 commented

  // Future<void> _getAvailableBiometric() async {
  //   List<BiometricType> availableBiometric;
  //   try {
  //     availableBiometric = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   setState(() {
  //     _availableBiometric = availableBiometric;
  //   });
  // }

  int _currentIndex = 0;
  final List<Widget> tabs = <Widget>[
    AccountTab(),
    PayTab(),
    TransferTab(),
    MobileTab()
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff242D36),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/accountunclick.png'),
            activeIcon: Image.asset('assets/accountclick.png'),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/paymentunclick.png'),
            activeIcon: Image.asset('assets/paymentclick.png'),
            label: 'Pay',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/transferunclick.png'),
            activeIcon: Image.asset('assets/transferclick.png'),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/phoneunclick.png'),
            activeIcon: Image.asset('assets/phoneclick.png'),
            label: 'Mobile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedLabelStyle: TextStyle(
          fontFamily: 'Segoe UI',
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Segoe UI',
        ),
        selectedItemColor: Color(0xffF9D47B),
        unselectedItemColor: Color(0xff787F85),
      ),
    );
  }
}
