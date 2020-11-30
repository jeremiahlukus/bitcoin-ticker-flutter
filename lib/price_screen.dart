import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_api.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

List<DropdownMenuItem> currencyListLoop() {
  List<DropdownMenuItem<String>> dropDownItems = [];
  for (var i in currenciesList) {
    var newItem = DropdownMenuItem(
      child: Text(i),
      value: i,
    );
    dropDownItems.add(newItem);
  }
  return dropDownItems;
}

List<Text> getIOSCurrency() {
  List<Text> iosDropdownItem = [];
  for (var i in currenciesList) {
    var newItem = Text(i);
    iosDropdownItem.add(newItem);
  }
  return iosDropdownItem;
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int btcExchangeRate = 0;
  int ethExchangeRate = 0;
  int ltcExchangeRate = 0;

  @override
  void initState() {
    super.initState();
    getExchangeRate('BTC', selectedCurrency);
    getExchangeRate('ETH', selectedCurrency);
    getExchangeRate('LTC', selectedCurrency);
  }

  getAndroidDropdown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyListLoop(),
      onChanged: (value) async {
        await getExchangeRate('BTC', value);
        setState(() async {
          selectedCurrency = value;
        });
        print(value);
      },
    );
  }

  getIOSPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) async {
        print(selectedIndex);
        await getExchangeRate('BTC', currenciesList[selectedIndex]);
        await getExchangeRate('ETH', currenciesList[selectedIndex]);
        await getExchangeRate('LTC', currenciesList[selectedIndex]);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: getIOSCurrency(),
    );
  }

  getExchangeRate(crypto, currency) async {
    var response = await CoinApi().getExchangeRate(crypto, currency);
    if (crypto == 'BTC') {
      setState(() {
        btcExchangeRate = response['rate'].round();
      });
    } else if (crypto == 'ETH') {
      setState(() {
        ethExchangeRate = response['rate'].round();
      });
    } else if (crypto == 'LTC') {
      setState(() {
        ltcExchangeRate = response['rate'].round();
      });
    }
  }

  exchangeCard(crypto, rate) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          exchangeCard('BTC', btcExchangeRate),
          exchangeCard('ETH', ethExchangeRate),
          exchangeCard('LTC', ltcExchangeRate),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropdown(),
          ),
        ],
      ),
    );
  }
}
