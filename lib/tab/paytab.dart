import 'package:flutter/material.dart';
import '../shared/constant.dart';

class PayTab extends StatelessWidget {
  String accountNumber = '164342333758';

  List<String> paymenType = ["NEW PAYEE", "jomPay"];

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
                height: size.height * 0.6,
                width: double.infinity,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
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
                          title: Text(
                            paymenType[index],
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 14,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          onTap: () {
                            if (paymenType[index]=='jomPay') {
                              Navigator.pushNamed(context, '/JomPay');
                            }
                          },
                        ),
                      );
                    }),
                    itemCount: paymenType.length),
              ),
            ),
          )
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
        //print(constraints.maxHeight);
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

