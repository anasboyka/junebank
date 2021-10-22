import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:junebank/services/auth.dart';
import 'package:junebank/shared/loading.dart';
import '../shared/constant.dart';
class Register extends StatefulWidget {
  final Function toggleview;
  Register({this.toggleview});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailcon = new TextEditingController();
  final passcon = new TextEditingController();
  final namecon = new TextEditingController();
  final confirmpasscon = new TextEditingController();
  final mobileNocon = new TextEditingController();
  String email = "",
      password = "",
      name = "",
      confirmPassword = "",
      mobileNo = "",
      error = "";
  bool loading = false, _ishidden = true;
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 100, 30, 7),
                        child: Text(
                          'PERSONAL DETAILS',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 50),
                        height: size.height * 0.5,
                        child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              designTextform(namecon, "Name"),
                              designTextform(emailcon, "Email"),
                              designTextform(passcon, "Password"),
                              designTextform(
                                  confirmpasscon, "Confirm Password"),
                              designTextform(mobileNocon, "Mobile Number"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: SizedBox(
                          width: double.infinity, //111,
                          height: 44,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(10),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color(0xffF2CD56),
                                ),
                              ),
                              child: Text(
                                'Register',
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
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password, name, mobileNo);
                                  if (result == null) {
                                    setState(() {
                                      error = "Please supply a valid email";
                                      loading = false;
                                    });
                                  }
                                }
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 7),
                        child: Text.rich(
                          TextSpan(
                              style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 9, //8,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700
                                  //fontStyle: FontStyle.normal
                                  ),
                              children: [
                                TextSpan(
                                    text:
                                        '*BY CREATING YOUR ACCOUNT OR SINGING IN, YOU AGREE TO OUR '),
                                TextSpan(
                                    text: 'TERMS AND CONDITIONS',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print('terms & condition');
                                      }),
                                TextSpan(text: '&'),
                                TextSpan(
                                    text: 'PRIVACY POLICY.',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print('privacy policy');
                                      }),
                              ]),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 15, //15
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(text: 'HAVE AN ACCOUNT?\n'),
                                  TextSpan(
                                      text: 'LOGIN',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          widget.toggleview();
                                        }),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
      ]),
    );
  }
  Padding designTextform(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: Container(
        height: 45,
        width: double.infinity,
        //padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: TextFormField(
          validator: (val) {
            if (hint == "Name") {
              return val.isEmpty ? "Enter a name" : null;
            } else if (hint == "Email") {
              return val.isEmpty ? "Enter an Email" : null;
            } else if (hint == "Password") {
              return val.length < 6
                  ? "password must be at least 6 character"
                  : null;
            } else if (hint == "Confirm Password") {
              if (controller.text != passcon.text) {
                print('password not match');
              }
              if (val.length < 6) {
                return "password must be at least 6 character";
              } else if (controller.text != passcon.text) {
                return "password must be same";
              } else {
                return null;
              }
            } else if (hint == "Mobile Number") {
              return val.isEmpty ? "Enter Mobile Phone Number" : null;
            } else {
              return null;
            }
          },
          onChanged: (val) {
            setState(() {
              if (hint == "Name") {
                name = val;
              } else if (hint == "Email") {
                email = val;
              } else if (hint == "Password") {
                password = val;
              } else if (hint == "Confirm Password") {
                confirmPassword = val;
              } else if (hint == "Mobile Number") {
                mobileNo = val;
              }
            });
          },
          obscureText: hint == 'Password' || hint == 'Confirm Password'
              ? _ishidden
              : false,
          controller: controller,
          keyboardType: hint == "Mobile Number"
              ? TextInputType.phone
              : TextInputType.text,
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
        ),
      ),
    );
  }
}
