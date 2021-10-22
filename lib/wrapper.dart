import 'package:flutter/material.dart';
import 'package:junebank/home.dart';
import 'package:junebank/models/user.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserFirebase>(context);
    //print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
