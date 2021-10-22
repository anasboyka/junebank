import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:junebank/shared/loading.dart';
import '../shared/constant.dart';
import 'package:junebank/services/auth.dart';

class LoginPage extends StatefulWidget {
  final Function toggleview;
  LoginPage({this.toggleview});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcon = new TextEditingController();
  final passcon = new TextEditingController();
  String email = "", password = "", error = "";
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar('assets/customerservice.png', true),
      drawer: Drawer(
        child: Text('test'),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/loginbg.png'), fit: BoxFit.cover),
          ),
        ),
        loading == true
            ? Loading()
            : SingleChildScrollView(
                child: Container(
                  height: size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: size.height * 0.60,
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/centerimg.png',
                              fit: BoxFit.contain,
                              height: 112,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'WELCOME',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.16,
                        //padding: EdgeInsets.only(bottom: 50),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 7),
                                child: Container(
                                  height: 44,
                                  width: double.infinity,
                                  child: textform(
                                      emailcon, "Username or Email", false),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 7),
                                child: Container(
                                  height: 44,
                                  width: double.infinity,
                                  child: textform(passcon, "Password", true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: 111,
                                height: 44,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(10),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Color(0xffF2CD56),
                                      ),
                                    ),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 18,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    onPressed: () async {
                                      if (_formkey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                                email, password);
                                        if (result == null) {
                                          print('cant sign in');

                                          setState(() {
                                            loading = false;
                                            error =
                                                "Could not Sign in with those credentials";
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      error)));
                                        }
                                      }
                                    }),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Helvetica Neue',
                                            fontSize: size.height * 0.0183, 
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    'DON\'T HAVE AN ACCOUNT?\n'),
                                            TextSpan(
                                                text: 'REGISTER',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        widget.toggleview();
                                                      }),
                                          ]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
      ]),
    );
  }

  TextFormField textform(
      TextEditingController controller, String hint, bool isHidden) {
    return TextFormField(
      validator: (val) {
        if (!isHidden) {
          return val.isEmpty ? "Enter an Email" : null;
        } else {
          return val.length < 6
              ? "password must be at least 6 character"
              : null;
        }
      },
      onChanged: (val) {
        setState(() {
          isHidden ? password = val : email = val;
        });
      },
      obscureText: isHidden,
      controller: controller,
      style: TextStyle(
        fontFamily: 'Segoe UI',
        fontSize: 20,
        color: const Color(0xffffffff),
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 20,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w300,
        ),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
      ),
    );
  }
}
