import "package:flutter/material.dart";
import 'package:peercoin/tools/app_localizations.dart';
import 'package:peercoin/models/wallettransaction.dart';
import 'package:intl/intl.dart';
import 'package:peercoin/tools/app_routes.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TransactionList extends StatefulWidget {
  final List<WalletTransaction> _walletTransactions;
  TransactionList(this._walletTransactions);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  String _filterChoice = "all";

  void _handleSelect(String newChoice) {
    setState(() {
      _filterChoice = newChoice;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<WalletTransaction> _reversedTx = widget._walletTransactions
        .where((element) => element.timestamp != -1) //filter phatom tx
        .toList()
        .reversed
        .toList();
    List<WalletTransaction> _filteredTx = _reversedTx;
    if (_filterChoice != "all") {
      _filteredTx = _reversedTx
          .where((element) => element.direction == _filterChoice)
          .toList();
    }

    return Expanded(
        child: Column(children: [
      if (_reversedTx.length > 0)
        Wrap(
          spacing: 8.0,
          children: <Widget>[
            ChoiceChip(
              visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
              label: Container(
                  child: Text(
                      AppLocalizations.instance.translate('transactions_in'))),
              selected: _filterChoice == "in",
              onSelected: (_) => _handleSelect("in"),
            ),
            ChoiceChip(
              visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
              label:
                  Text(AppLocalizations.instance.translate('transactions_all')),
              selected: _filterChoice == "all",
              onSelected: (_) => _handleSelect("all"),
            ),
            ChoiceChip(
              visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
              label:
                  Text(AppLocalizations.instance.translate('transactions_out')),
              selected: _filterChoice == "out",
              onSelected: (_) => _handleSelect("out"),
            ),
          ],
        ),
      Expanded(
        child: _reversedTx.length == 0
            ? Center(
                child: Text(
                    AppLocalizations.instance.translate('transactions_none')),
              )
            : GestureDetector(
                onHorizontalDragEnd: (dragEndDetails) {
                  if (dragEndDetails.primaryVelocity < 0) {
                    //left swipe
                    if (_filterChoice == "in") {
                      _handleSelect("all");
                    } else if (_filterChoice == "all") {
                      _handleSelect("out");
                    }
                  } else if (dragEndDetails.primaryVelocity > 0) {
                    //right swipe
                    if (_filterChoice == "out") {
                      _handleSelect("all");
                    } else if (_filterChoice == "all") {
                      _handleSelect("in");
                    }
                  }
                },
                child: ListView.builder(
                  itemCount: _filteredTx.length,
                  itemBuilder: (_, i) {
                    int currentConfirmations = _filteredTx[i].confirmations;
                    return Card(
                      child: ListTile(
                        onTap: () => Navigator.of(context)
                            .pushNamed(Routes.Transaction, arguments: [
                          _filteredTx[i],
                          ModalRoute.of(context).settings.arguments
                        ]),
                        leading: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                _filteredTx[i].direction == "in"
                                    ? Icons.west
                                    : Icons.east,
                                size: 18,
                              ),
                              AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  child: _filteredTx[i].broadCasted == false
                                      ? Text("?",
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor))
                                      : CircularStepProgressIndicator(
                                          totalSteps: 6,
                                          currentStep: currentConfirmations,
                                          width: 20,
                                          height: 20,
                                          selectedColor:
                                              Theme.of(context).primaryColor,
                                          unselectedColor:
                                              Theme.of(context).accentColor,
                                          stepSize: 4,
                                          roundedCap: (_, __) => true,
                                        )),
                              Text(
                                DateFormat("d. MMM").format(
                                    _filteredTx[i].timestamp != null
                                        ? DateTime.fromMillisecondsSinceEpoch(
                                            _filteredTx[i].timestamp * 1000)
                                        : DateTime.now()),
                                style: TextStyle(
                                  fontWeight: _filteredTx[i].timestamp != null
                                      ? FontWeight.w500
                                      : FontWeight.w300,
                                ),
                                textScaleFactor: 0.8,
                              )
                            ]),
                        title: Center(
                          child: Text(
                            _filteredTx[i].txid,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 0.9,
                          ),
                        ),
                        subtitle: Text(
                          _filteredTx[i].address,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (_filteredTx[i].direction == "in" ? "+" : "-") +
                                  (_filteredTx[i].value / 1000000).toString(),
                              style: TextStyle(
                                  fontWeight: _filteredTx[i].timestamp != null
                                      ? FontWeight.bold
                                      : FontWeight.w300,
                                  color: _filteredTx[i].direction == "out"
                                      ? Colors.redAccent.shade200
                                      : Colors.black),
                            ),
                            if (_filteredTx[i].direction == "out")
                              Text(
                                AppLocalizations.instance.translate(
                                    'transactions_fee', {
                                  'amount': "${_filteredTx[i].fee / 1000000}"
                                }),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).accentColor),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      )
    ]));
  }
}
