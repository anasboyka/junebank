import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:junebank/services/database.dart';
import 'package:local_auth/local_auth.dart';

class ConfirmTransferForm extends StatefulWidget {
  Map argument = {};
  ConfirmTransferForm({Key key, this.argument}) : super(key: key);

  @override
  _ConfirmTransferForm createState() => _ConfirmTransferForm();
}

class _ConfirmTransferForm extends State<ConfirmTransferForm> {
  String title1 = "Transfer Type",
      subtitle1 = "Funds transfer",
      hint1 = "N/A",
      hint2 = "transfer details";
  bool enabled1 = false, loading = false;
  bool authenticated = false;
  LocalAuthentication localAuth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometric;
  String autherized = "not Autherized";

  final FirebaseAuth auth = FirebaseAuth.instance;
  String getCurrentUserId() {
    final User user = auth.currentUser;
    //print(user.uid);
    return user.uid;
  }

  Future getdataUser(String collection,String id, String data) async {
    var value = await DatabaseService().getdata(collection,id, data);
    return value;
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    try {
      authenticated = await localAuth.authenticate(
          localizedReason: 'Fingerprint ID',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      autherized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      print(autherized);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.height);
    print(kToolbarHeight);
    double bodySize = size.height - kToolbarHeight;
    print(widget.argument['amount']);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff47838E),
        shadowColor: Colors.transparent,
        title: Text(
          'TRANSFER DETAILS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      //extendBodyBehindAppBar: true,
      body: Stack(children: [
        Opacity(
            opacity: loading == true ? 0.5 : 1,
            child: Container(
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: bodySize * 0.875,
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      children: [
                        listTitleConfirmTransfer("TRANSFER FROM"),
                        listDataConfirmTransfer(
                            widget.argument['transferFrom']),
                        listTitleConfirmTransfer("TRANSFER TYPE"),
                        listDataConfirmTransfer(
                            widget.argument['transferType']),
                        listTitleConfirmTransfer("TRANSFER DATE"),
                        listDataConfirmTransfer(
                            widget.argument['transferDate']),
                        listTitleConfirmTransfer("RECIPIENT ACCOUNT NUMBER"),
                        listDataConfirmTransfer(
                            widget.argument['recipient account number']),
                        listTitleConfirmTransfer("RECIPIENT ACCOUNT NAME"),
                        listDataConfirmTransfer(
                            widget.argument['recipient account name']),
                        listTitleConfirmTransfer("AMOUNT"),
                        listDataConfirmTransfer(
                            'RM ${widget.argument['amount']}'),
                        listTitleConfirmTransfer("RECIPIENT REFERENCE"),
                        listDataConfirmTransfer(
                            widget.argument['transfer detail']),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Container(
                        width: double.infinity,
                        color: Color(0xffFECD09),
                        child: Center(
                          child: Text(
                            'CONFIRM & TRANSFER',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () async {
                        await _authenticate();
                        if (authenticated) {
                          String fromAccountName = await getdataUser(
                              'account',getCurrentUserId(), 'accountName');
                          String toAccountName = await getdataUser(
                              'account',widget.argument['id'], 'accountName');
                          int fromAccountNumber = await getdataUser(
                              'account',getCurrentUserId(), 'accountNumber');
                          int toAccountNumber = await getdataUser(
                              'account',widget.argument['id'], 'accountNumber');
                          loading = true;
                          await DatabaseService(uid: getCurrentUserId())
                              .transfer(
                            widget.argument['id'],
                            double.parse(widget.argument['amount']),
                            widget.argument['transfer detail'],
                            toAccountName,
                            toAccountNumber,
                            fromAccountName,
                            fromAccountNumber,
                          );
                          loading = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Transfer Success')));
                          return Navigator.pushReplacementNamed(context, '/');
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
        loading == true
            ? Center(child: CircularProgressIndicator())
            : Opacity(opacity: 1)
      ]),
    );
  }

  Container listDataConfirmTransfer(String data) {
    return Container(
      //height: 47,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xffDBDBDB),
          ),
        ),
      ),
      child: Text(
        data,
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Container listTitleConfirmTransfer(String title) {
    return Container(
      height: 45,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xffDBDBDB),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 14,
          color: const Color(0xff9b9b9b),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
