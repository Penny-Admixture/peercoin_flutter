import "package:flutter/material.dart";
import 'package:peercoin/models/wallettransaction.dart';
import 'package:peercoin/widgets/receive_tab.dart';
import 'package:peercoin/widgets/send_tab.dart';
import 'package:peercoin/widgets/transactions_list.dart';

class WalletContentSwitch extends StatelessWidget {
  final int pageIndex;
  final List<WalletTransaction> walletTransactions;
  final String unusedAddress;
  final Function changeIndex;

  WalletContentSwitch(
      {this.pageIndex,
      this.walletTransactions,
      this.unusedAddress,
      this.changeIndex});

  @override
  Widget build(BuildContext context) {
    switch (pageIndex) {
      case 0:
        return Expanded(
            child: SingleChildScrollView(child: ReceiveTab(unusedAddress)));
      case 1:
        return TransactionList(
            walletTransactions != null ? walletTransactions : []);
      case 2:
        return Expanded(
            child: SingleChildScrollView(child: SendTab(changeIndex)));
      default:
        return Container();
    }
  }
}
