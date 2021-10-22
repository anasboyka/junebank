import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:junebank/services/database.dart';
import 'dart:math' as math;

class JomPay extends StatefulWidget {
  Map argument = {};
  JomPay({Key key, this.argument}) : super(key: key);
  @override
  _JomPayState createState() => _JomPayState();
}

class _JomPayState extends State<JomPay> {
  final _formkey = GlobalKey<FormState>();

  String date = "", billerCode = "", detail = "", amount = "", refrence = "";
  final datecon = new TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
  final billerCodecon = new TextEditingController();
  final referenceIdcon = new TextEditingController();
  final amountcon = new TextEditingController(text: "0.00");
  final detailcon = new TextEditingController();

  bool loading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  String getCurrentUserId() {
    final User user = auth.currentUser;
    //print(user.uid);
    return user.uid;
  }

  Future getdataUser(String collection, String id, String data) async {
    var value = await DatabaseService().getdata(collection, id, data);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        Opacity(
          opacity: loading == true ? 0.5 : 1,
          child: Column(
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
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        textformAmountWidget(size),
                        Container(
                          height: size.height * 0.3,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              //print("widget under amount ${constraints.maxHeight}");
                              return ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  textformDetail(
                                      constraints,
                                      "billerCode",
                                      "Biller Code",
                                      true,
                                      "1234",
                                      billerCodecon),
                                  textformDetail(
                                      constraints,
                                      "reference",
                                      "REFERENCE ID",
                                      true,
                                      "N/A",
                                      referenceIdcon),
                                  textformDetail(
                                      constraints,
                                      "detail",
                                      "Additional Detail",
                                      true,
                                      "N/A",
                                      detailcon),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        Container(
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: TextButton(
                            child: Text(
                              'PROCEED',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 18,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(10),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff319E67),
                              ),
                            ),
                            onPressed: () async {
                              billerCode = billerCodecon.text;
                              refrence = referenceIdcon.text;
                              amount = amountcon.text;
                              detail = detailcon.text;

                              if (amount.isEmpty || double.parse(amount) < 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'amount must exceed RM 1 and above')));
                              } else if (detail.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('reference cannot be empty')));
                              } else {
                                loading = true;
                                String id = await DatabaseService()
                                    .checkBillerCodeExist(billerCode
                                        .replaceAll('.', "")
                                        .replaceAll(',', ''));
                                print(id);
                                if (id != null) {
                                  loading = false;
                                  String accountName = await getdataUser(
                                      'account',
                                      getCurrentUserId(),
                                      'accountName');
                                  int accountNumber = await getdataUser(
                                      'account',
                                      getCurrentUserId(),
                                      'accountNumber');
                                  String recipientName = await getdataUser(
                                      'JomPay', id, 'accountName');
                                  await DatabaseService(uid: getCurrentUserId())
                                      .jomPay(
                                          id,
                                          double.parse(amount),
                                          refrence,
                                          accountName,
                                          detail,
                                          accountNumber,
                                          recipientName,
                                          billerCode);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Paid Successfully'),
                                    ),
                                  );
                                } else {
                                  print(null);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('biller code not exist'),
                                    ),
                                  );
                                }
                              }
                              print('clicked');
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        loading == true
            ? Center(child: CircularProgressIndicator())
            : Opacity(opacity: 1)
      ]),
    );
  }

  Container textformDetail(
      BoxConstraints constraints,
      String category,
      String title,
      bool enabled,
      String hint,
      TextEditingController controller) {
    return Container(
      width: double.infinity,
      height: constraints.maxHeight / 3,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffDBDBDB), width: 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 7),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IntrinsicWidth(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 17,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w300,
              ),
              keyboardType: (category == "billerCode")
                  ? TextInputType.numberWithOptions(decimal: false)
                  : TextInputType.text,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 17,
                  color: const Color(0xffdbdbdb),
                ),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container textformAmountWidget(
      Size size /*,TextEditingController controller*/) {
    return Container(
      height: size.height * 0.1,
      width: double.infinity,
      color: Color(0xffFFC83D),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'AMOUNT',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: IntrinsicWidth(
              child: TextFormField(
                controller: amountcon,
                onChanged: (val) {
                  setState(() {});
                },
                //initialValue: '0.00',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 30,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.start,
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefix: Text(
                    'RM ',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 30,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
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
        contentHeaderPayTab(context),
      ],
    );
  }

  Widget contentHeaderPayTab(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //print(size);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        print(constraints.maxHeight);
        double height = constraints.maxHeight;
        return Padding(
          padding: EdgeInsets.only(top: height * 0.1),
          child: Center(
            child: Container(
              height: size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/personalaccount.png'),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Personal Account-i',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 14,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'phoneNumber',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12,
                            color: const Color(0x80ffffff),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                    child: Image.asset(
                      'assets/arrowto.png',
                      height: 28,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/otheraccount.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(45, 2, 45, 2),
                        child: Text(
                          'Pay To',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 14,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
