import 'package:flutter/material.dart';
import 'package:junebank/shared/constant.dart';

class TransferTab extends StatefulWidget {
  @override
  _TransferTabState createState() => _TransferTabState();
}

class _TransferTabState extends State<TransferTab> {
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
              child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                  color: Color(0xffDBDBDB), width: 0.5),
                              bottom: BorderSide(
                                  color: Color(0xffDBDBDB), width: 0.5),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/transfertoownlogo.png'),
                              SizedBox(
                                width: 158.0,
                                child: Text(
                                  'Transfer to Own Account',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 15,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          print('transfer own account');
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  color: Color(0xffDBDBDB), width: 0.5),
                              bottom: BorderSide(
                                  color: Color(0xffDBDBDB), width: 0.5),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/transfertootherlogo.png'),
                              SizedBox(
                                width: 158.0,
                                child: Text(
                                  'Transfer to Other Account',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 15,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          return Navigator.pushNamed(
                              context, '/transferformfield',
                              arguments: {'type': 'transfer to other account'});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                  color: Color(0xffDBDBDB), width: 0.5),
                              top: BorderSide(
                                  color: Color(0xffDBDBDB), width: 0.5),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/duitnowlogo.png'),
                              SizedBox(
                                width: 158.0,
                                child: Text(
                                  'Transfer via DuitNow',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 15,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          print('duitnow');
                          return Navigator.pushNamed(
                              context, '/duitnowformfield',
                              arguments: {'type': 'duitnow'});
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                color: Color(0xffDBDBDB), width: 0.5),
                            top: BorderSide(
                                color: Color(0xffDBDBDB), width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ))
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
        contentHeaderTransferTab(context),
      ],
    );
  }

  Widget contentHeaderTransferTab(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: SizedBox(
      width: 265.0,
      height: 74.0,
      child: Text(
        'What would you like to do?',
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 28,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    ));
  }
}
