import 'package:flutter/material.dart';
import 'package:junebank/bloc/application_block.dart';
import 'package:junebank/tab/accounttab.dart';
import 'package:junebank/home.dart';
import 'package:junebank/authenticate/login.dart';
import 'package:junebank/tab/mobiletab.dart';
import 'package:junebank/models/user.dart';
import 'package:junebank/tab/paytab.dart';
import 'package:junebank/services/auth.dart';
import 'package:junebank/tab/transfertab.dart';
import 'package:junebank/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:junebank/routeGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserFirebase>.value(
      initialData: null,
      value: AuthService().user,
      child: ChangeNotifierProvider(
        create: (context)=>AppliactionBloc(),
              child: MaterialApp(
          //home: Wrapper(),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
