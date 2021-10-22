import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:junebank/services/database.dart';
import 'package:junebank/shared/loading.dart';
import 'package:local_auth/local_auth.dart';

class ViewHistory extends StatefulWidget {
  Map argument = {};
  ViewHistory({Key key, this.argument}) : super(key: key);
  @override
  _ViewHistoryState createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff47838E),
        shadowColor: Colors.transparent,
        title: Text(
          'TRANSACTION HISTORY',
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
              child: getTransactionList(),
            )),
        loading == true
            ? Center(child: CircularProgressIndicator())
            : Opacity(opacity: 1)
      ]),
    );
  }

  StreamBuilder getTransactionList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('account')
          .doc(getCurrentUserId())
          .collection('transaction')
          .orderBy('transactionDate', descending: true)
          .snapshots(),
      // .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } else {
          //print(snapshot.data.docs[0]['amount']);
          return ListView.builder(
              padding: EdgeInsets.all(0),
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) {
                String date = (DateFormat('yyyy-MM-dd').format(
                    snapshot.data.docs[index]['transactionDate'].toDate()));
                return Container(
                  child: Column(
                    children: [
                      (index == 0)
                          ? listTitleConfirmTransfer(date)
                          : (date ==
                                  DateFormat('yyyy-MM-dd').format(snapshot
                                      .data.docs[index - 1]['transactionDate']
                                      .toDate()))
                              ? Container() //VerticalDivider(width: 1,color: Colors.black,)
                              : listTitleConfirmTransfer(date),
                      listDataConfirmTransfer(snapshot, index),
                    ],
                  ),
                );
              }));
        }
      },
    );
  }

  Container listTitleConfirmTransfer(String data) {
    return Container(
      //height: 47,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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

  Container listDataConfirmTransfer(
      AsyncSnapshot<dynamic> snapshot, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xffDBDBDB),
          ),
        ),
      ),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            snapshot.data.docs[index]['isReceive']
                ? Image.asset(
                    'assets/money_in_black_big.png',
                    height: 24,
                  )
                : Image.asset(
                    'assets/money_out_black_big.png',
                    height: 24,
                  ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            snapshot.data.docs[index]['isReceive']
                ? Text(
                    'RM ${snapshot.data.docs[index]['amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 12,
                      color: const Color(0xff509576),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  )
                : Text(
                    '-RM ${snapshot.data.docs[index]['amount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 12,
                      color: const Color(0xffc24d3a),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  )
          ],
        ),
        title: Text(
          snapshot.data.docs[index]['transactionTitle'],
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 14,
            color: Colors.black.withOpacity(0.7), 
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
