import 'package:bitcoin_ticker/network.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

const url = 'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String btcValue = '?';
  String ethValue = '?';
  String ltcValue = '?';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (newValue) {
        setState(() {
          selectedCurrency = newValue;
          getTickerData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 35.0,
        onSelectedItemChanged: (selectedIndex) {
          selectedCurrency = currenciesList[selectedIndex];
          getTickerData();
        },
        children: pickerItems);
  }

  void getTickerData() async {
    btcValue = '?';
    NetworkHelper network =
        NetworkHelper(url: '$url${cryptoList[0]}$selectedCurrency');
    var btcResponse = await network.getTickerData();
    network = NetworkHelper(url: '$url${cryptoList[1]}$selectedCurrency');
    var ethResponse = await network.getTickerData();
    network = NetworkHelper(url: '$url${cryptoList[2]}$selectedCurrency');
    var ltcResponse = await network.getTickerData();
    setState(() {
      btcValue = btcResponse['ask'].round().toString();
      ethValue = ethResponse['ask'].round().toString();
      ltcValue = ltcResponse['ask'].round().toString();
    });
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
          TickerCard(
            type: cryptoList[0],
            value: btcValue,
            currency: selectedCurrency,
          ),
          TickerCard(
            type: cryptoList[1],
            value: ethValue,
            currency: selectedCurrency,
          ),
          TickerCard(
            type: cryptoList[2],
            value: ltcValue,
            currency: selectedCurrency,
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iosPicker() : androidDropdown()),
        ],
      ),
    );
  }
}

class TickerCard extends StatelessWidget {
  TickerCard({this.type, this.value, this.currency});

  final String type;
  final String value;
  final String currency;

  @override
  Widget build(BuildContext context) {
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
            '1 $type = $value $currency',
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
}
