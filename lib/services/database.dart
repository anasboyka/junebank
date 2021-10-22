import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:junebank/models/account.dart';
import 'package:junebank/models/transaction.dart' as trans;
import 'dart:async';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference accountCollection =
      FirebaseFirestore.instance.collection('account');
  final CollectionReference prepaidReloadCollection =
      FirebaseFirestore.instance.collection('PrepaidReload');
  final CollectionReference jomPayCollection =
      FirebaseFirestore.instance.collection('JomPay');


  Future updateUserdata(
      String accountName,
      int accountNumber,
      String accountType,
      double balance,
      String email,
      String password,
      String mobileNo) async {
    return await accountCollection.doc(uid).set({
      'accountName': accountName,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'balance': balance,
      'email': email,
      'password': password,
      'mobileNo': mobileNo
    }).then((_) {
      print('success');
      accountCollection.doc(uid).collection('transaction').add({
        'amount': 10,
        'transactionDate': DateTime.now(),
        'isReceive': true,
        'transactionTitle': "Account Created",
        'transferFromName': 'Admin',
        'transferFromAccountNumber': 52213110000,
      });
    });
  }

  Future pay(double amount, String title, String transferName,
      int transferAccountNumber, String telco, int phoneNUmber) async {
    //print(docId);
    await handleBalance(amount, true, this.uid);
    await accountCollection.doc(this.uid).collection('transaction').add({
      'amount': amount,
      'transactionDate': DateTime.now(),
      'isReceive': false,
      'transactionTitle': title,
      'transferName': telco,
      'transferAccountNumber': phoneNUmber,
    });
    return prepaidReloadCollection.add({
      'amount': amount,
      'transactionDate': DateTime.now(),
      'transactionTitle': title,
      'transferFromName': transferName,
      'transferFromAccountNumber': transferAccountNumber,
    });
  }

  Future jomPay(
      String id,
      double amount,
      String refrence,
      String accountName,
      String additionalDetail,
      int accountNumber,
      String recepientName,
      String billerCode) async {
    //print(docId);
    await handleBalance(amount, true, this.uid);
    await accountCollection.doc(this.uid).collection('transaction').add({
      'amount': amount,
      'transactionDate': DateTime.now(),
      'isReceive': false,
      'transactionTitle': refrence,
      'transferName': recepientName,
      'transferAccountNumber': billerCode,
    });
    await addBalance(amount, false, id);
    return jomPayCollection.doc(id).collection('transaction').add({
      'amount': amount,
      'transactionDate': DateTime.now(),
      'transactionTitle': additionalDetail,
      'transferFromName': accountName,
      'transferFromAccountNumber': accountNumber,
    });
  }

  Future transfer(
      String docId,
      double amount,
      String title,
      String transferName,
      int transferAccountNumber,
      String transferToName,
      int transferToAccountNumber) async {
    //print(docId);
    await handleBalance(amount, true, this.uid);
    await accountCollection.doc(this.uid).collection('transaction').add({
      'amount': amount,
      'transactionDate': DateTime.now(),
      'isReceive': false,
      'transactionTitle': title,
      'transferName': transferName,
      'transferAccountNumber': transferAccountNumber,
    });
    await handleBalance(amount, false, docId);
    return await accountCollection.doc(docId).collection('transaction').add({
      'amount': amount,
      'transactionDate': DateTime.now(),
      'isReceive': true,
      'transactionTitle': title,
      'transferName': transferToName,
      'transferAccountNumber': transferToAccountNumber,
    });
  }

  Future handleBalance(double amount, bool deduct, String id) async {
    double currentBalance = 0;
    try {
      final DocumentSnapshot docsnap = await FirebaseFirestore.instance
          .collection('account')
          .doc(id)
          .snapshots()
          .first
          .then((value) => value);
      print(docsnap['balance']);

      if (deduct == true) {
        currentBalance = docsnap['balance'] - amount;
      } else {
        currentBalance = docsnap['balance'] + amount;
      }
      await accountCollection.doc(id).update({
        'balance': currentBalance,
      });
    } catch (e) {
      print(e);
    }
  }

  Future addBalance(double amount, bool deduct, String id) async {
    double currentBalance = 0;
    try {
      final DocumentSnapshot docsnap = await FirebaseFirestore.instance
          .collection('JomPay')
          .doc(id)
          .snapshots()
          .first
          .then((value) => value);
      print(docsnap['balance']);

      if (deduct == true) {
        currentBalance = docsnap['balance'] - amount;
      } else {
        currentBalance = docsnap['balance'] + amount;
      }
      await jomPayCollection.doc(id).update({
        'balance': currentBalance,
      });
    } catch (e) {
      print(e);
    }
  }

  Future getdata(String collection, String id, String data) async {
    final DocumentSnapshot docsnap = await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .snapshots()
        .first
        .then((value) => value);
    //var data =  docsnap[data];
    return docsnap[data];
  }

  Future<String> checkAccountExist(int accountNumber) async {
    try {
      final DocumentSnapshot docsnap = await FirebaseFirestore.instance
          .collection('account')
          .where('accountNumber', isEqualTo: accountNumber)
          .snapshots()
          .first
          .then((value) {
        return value.docs.first;
      });
      print(docsnap.id);
      return docsnap.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> checkPhoneNumberExist(String phoneNumber) async {
    try {
      final DocumentSnapshot docsnap = await FirebaseFirestore.instance
          .collection('account')
          .where('mobileNo', isEqualTo: phoneNumber)
          .snapshots()
          .first
          .then((value) {
        return value.docs.first;
      });
      print(docsnap.id);
      return docsnap.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> checkBillerCodeExist(String billerCode) async {
    try {
      final DocumentSnapshot docsnap = await FirebaseFirestore.instance
          .collection('JomPay')
          .where('billercode', isEqualTo: billerCode)
          .snapshots()
          .first
          .then((value) {
        return value.docs.first;
      });
      print(docsnap.id);
      return docsnap.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<Account> _accountListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Account(
            accountName: doc.data()['accountName'] ?? '',
            accountNumber: doc.data()['accountNumber'] ?? '',
            balance: doc.data()['balance'] ?? '',
            email: doc.data()['email'] ?? '',
            password: doc.data()['password'] ?? '',
            mobileNo: doc.data()['mobileNo'] ?? ''))
        .toList();
  }

  List<trans.Transaction> _transactionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => trans.Transaction(
              amount: doc.data()['amount'] ?? 0,
              transactionDate: doc.data()['transactionDate'] ?? DateTime.now(),
              isReceive: doc.data()['isReceive'] ?? true,
              transactionTitle: doc.data()['transactionTitle'] ?? '',
            ))
        .toList();
  }

  Stream<List<Account>> get account {
    return accountCollection.snapshots().map(_accountListFromSnapshot);
  }

  Stream<List<trans.Transaction>> get transaction {
    return accountCollection
        .doc(uid)
        .collection('transaction')
        .snapshots()
        .map(_transactionListFromSnapshot);
  }
}
