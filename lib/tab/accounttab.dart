import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:junebank/class/transactionhistory.dart';
import 'package:junebank/class/transactionlist.dart';
import 'package:junebank/models/account.dart';
import 'package:junebank/services/database.dart';
import 'package:junebank/shared/constant.dart';
import 'package:junebank/shared/loading.dart';
import 'package:provider/provider.dart';

import 'package:junebank/models/transaction.dart' as trans;

class AccountTab extends StatefulWidget {
  @override
  _AccountTabState createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Map data;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String account = 'Account';

  String getCurrentUserId() {
    final User user = auth.currentUser;
    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar('assets/logoutbig.png', false),
      drawer: Drawer(
        child: Text('test'),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size.height * 0.4,
            width: double.infinity,
            child: header(context),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Container(
                    color: Color(0xffF2F2F2),
                    height: size.height * 0.6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              print('view full history clicked');
                              return Navigator.pushNamed(
                                  context, '/viewHistory');
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 11, 11, 0),
                              child: Text(
                                'view full history >>',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 14,
                                  color: const Color(0x80000000),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: cardAccountBalance(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
                            child: Text(
                              'Recent transaction',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: const Color(0x80000000),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: Color(0xffDBDBDB),
                                ),
                                bottom: BorderSide(
                                  width: 1,
                                  color: Color(0xffDBDBDB),
                                ),
                              ),
                            ),
                            child: getTransactionList(),
                          ),
                        )
                      ],
                    ))),
          )
        ],
      ),
    );
  }

  Card cardAccountBalance() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListTile(
              title: getDataInText(
                'accountType',
                TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 14,
                  color: const Color(0xff000000),
                ),
                TextAlign.left,
              ),
              subtitle: getDataInText(
                'accountNumber',
                TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 12,
                  color: const Color(0x80000000),
                ),
                TextAlign.left,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(25.0),
              child: showBalance(
                  TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14,
                    color: const Color(0xff509576),
                    fontWeight: FontWeight.w700,
                  ),
                  TextAlign.left)),
        ],
      ),
    );
  }

  Stack header(BuildContext context) {
    return Stack(
      children: [
        Image(
          width: double.infinity,
          image: AssetImage(
            'assets/headersmallbgblur.png',
          ),
          fit: BoxFit.cover,
        ),
        Center(
          child: showBalance(
              TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 29,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w300,
              ),
              TextAlign.left),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.fromLTRB(0, 46, 0, 63),
          child: SizedBox(
            height: 33,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: Colors.transparent),
              child: MaterialButton(
                  color: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                        child: Text(
                          '$account',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 18,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {}),
            ),
          ),
        )
      ],
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
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } else {
          return ListView.builder(
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  snapshot.data.docs.length < 4 ? snapshot.data.docs.length : 4,
              itemBuilder: ((context, index) {
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
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd').format(snapshot
                          .data.docs[index]['transactionDate']
                          .toDate()),
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                );
              }));
        }
      },
    );
  }

  StreamBuilder<DocumentSnapshot> showBalance(
      TextStyle style, TextAlign textAlign) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('account')
          .doc(getCurrentUserId())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data.exists) {
          return Loading();
        } else {
          var userDocument = snapshot.data;
          return Text(
            'RM ' + userDocument["balance"].toStringAsFixed(2),
            style: style,
            textAlign: textAlign,
          );
        }
      },
    );
  }

  StreamBuilder<DocumentSnapshot> getDataInText(
      String data, TextStyle textStyle, TextAlign textAlign) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('account')
          .doc(getCurrentUserId())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data.exists) {
          return Loading();
        } else {
          var userDocument = snapshot.data;
          return Text(
            userDocument[data].toString(),
            style: textStyle,
            textAlign: textAlign,
          );
        }
      },
    );
  }
}
