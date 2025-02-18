import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peercoin/tools/app_localizations.dart';
import 'package:peercoin/models/availablecoins.dart';
import 'package:peercoin/models/coinwallet.dart';
import 'package:peercoin/models/wallettransaction.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDetails extends StatelessWidget {
  void _launchURL(_url) async {
    await canLaunch(_url)
        ? await launch(
            _url,
          )
        : throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as List;
    final WalletTransaction _tx = args[0];
    final CoinWallet _coinWallet = args[1];
    final String baseUrl =
        AvailableCoins().getSpecificCoin(_coinWallet.name).explorerTxDetailUrl;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        AppLocalizations.instance.translate('transaction_details'),
      )),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.translate('id'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_tx.txid)
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.translate('time'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_tx.timestamp != null
                  ? DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(_tx.timestamp * 1000))
                  : AppLocalizations.instance.translate('unconfirmed'))
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.instance.translate('tx_value'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText((_tx.value / 1000000).toString() +
                  " " +
                  _coinWallet.letterCode)
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.translate('tx_fee'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(
                  (_tx.fee / 1000000).toString() + " " + _coinWallet.letterCode)
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.translate('tx_address'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_tx.address)
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.translate('tx_direction'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_tx.direction)
            ],
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.instance.translate('tx_confirmations'),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(_tx.confirmations.toString())
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
                onPressed: () => _launchURL(baseUrl + "${_tx.txid}"),
                icon: Icon(
                  Icons.search,
                ),
                label: Text(
                  AppLocalizations.instance.translate('tx_view_in_explorer'),
                )),
          )
        ],
      ),
    );
  }
}
