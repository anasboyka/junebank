import 'package:flutter/material.dart';
import 'package:junebank/services/auth.dart';

AppBar buildAppBar(String imageAssetPath, bool titleVisible) {
  final AuthService _auth = AuthService();

  return AppBar(
    title: titleVisible
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logojunebankbig.png',
                fit: BoxFit.contain,
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Junebank',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 29,
                    color: const Color(0xfff8cf0d),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          )
        : null,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Builder(
      builder: (context) => IconButton(
        iconSize: 35,
        icon: Image.asset(
          'assets/menudrawer.png',
        ),
        onPressed: () {
          print('clicked');
          return Scaffold.of(context).openDrawer();
        },
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
    ),
    actions: [
      IconButton(
        iconSize: 35,
        icon: Image.asset(
          imageAssetPath,
          fit: BoxFit.cover,
          height: 27,
        ),
        onPressed: () async {
          if (imageAssetPath != "assets/customerservice.png") {
            await _auth.signout();
          }
          print('action button clicked');
        },
      ),
    ],
  );
}
