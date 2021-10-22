import 'package:flutter/cupertino.dart';
import 'package:junebank/tab/subaccounttab/viewhistory.dart';
import 'package:junebank/tab/submobiletab/map.dart';
import 'package:junebank/tab/subpaytab/jompay.dart';
import 'package:junebank/tab/subtransfertab/confirmationtransfer.dart';
import 'package:junebank/tab/subtransfertab/duitnow.dart';
import 'package:junebank/tab/submobiletab/prepaid_reload.dart';
import 'package:junebank/tab/subtransfertab/transfer.dart';
import 'package:junebank/wrapper.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => Wrapper());
      case '/transferformfield':
        return CupertinoPageRoute(builder: (_) => TransferFormDetail());
      case '/confirmtransferform':
        return CupertinoPageRoute(
          builder: (_) => ConfirmTransferForm(
            argument: args,
          ),
        );
      case '/duitnowformfield':
        return CupertinoPageRoute(builder: (_) => DuitnowFormDetail());
      case '/PrepaidReloadForm':
        return CupertinoPageRoute(builder: (_) => PrepaidReload());
      case '/viewHistory':
        return CupertinoPageRoute(builder: (_) => ViewHistory());
      case '/JomPay':
        return CupertinoPageRoute(builder: (_) => JomPay());
      case '/mapgoogle':
        return CupertinoPageRoute(builder: (_) => MapGoogle());
      default:
        return CupertinoPageRoute(builder: (_) => Wrapper());
    }
  }
}
