import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:junebank/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:junebank/models/transaction.dart' as trans;

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<List<trans.Transaction>>(context);
    print(transactions);
    if (transactions != null) {
      transactions.forEach((element) {
        print(element.amount);
        print(element.isReceive);
        print(element.transactionDate);
        print(element.transactionTitle);
      });
    }
    // if (transactions!=null) {

    //   transactions.forEach((transaction) {
    //     print(transaction.amount);
    //     print(transaction.transactionDate);
    //     print(transaction.isReceive);
    //     print(transaction.transactionTitle);
    //   });
    // }

    //return Container();
    return ListView.builder(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: transactions.length,
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
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  transactions[index].isReceive
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
                  transactions[index].isReceive
                      ? Text(
                          'RM ${transactions[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12,
                            color: const Color(0xff509576),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                      : Text(
                          '-RM ${transactions[index].amount.toStringAsFixed(2)}',
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
                transactions[index].transactionTitle,
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7), //Color(0x80000000),
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                DateFormat('yyyy-MM-dd')
                    .format(transactions[index].transactionDate),
                style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 12,
                    color:
                        Colors.black.withOpacity(0.5) //const Color(0x80000000),
                    ),
                textAlign: TextAlign.left,
              ),
            ),
          );
        }));
  }
}
