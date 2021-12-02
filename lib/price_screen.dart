import 'dart:convert';

import 'package:bitcoin_ticker/api.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String btc = 'NA', ltc = 'NA', eth = 'NA';
  String currencySelected = 'INR';
  String currencySymbol = '';

  //https://blockchain.info/ticker';

  Future<void> getPrice(String currency) async {
    final snackBar = SnackBar(
        content: Text(
            'Too many requests -- You have exceeded your API key rate limits'));
    final urlBtc =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$currencySelected?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(urlBtc));

    if (response.statusCode == 429) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    var jsonData = jsonDecode(response.body);
    var priceBtc = jsonData['rate'];

    final urlEth =
        'https://rest.coinapi.io/v1/exchangerate/ETH/$currencySelected?apikey=$apiKey';
    response = await http.get(Uri.parse(urlEth));
    jsonData = jsonDecode(response.body);
    var priceEth = jsonData['rate'];

    final urlLtc =
        'https://rest.coinapi.io/v1/exchangerate/LTC/$currencySelected?apikey=$apiKey';
    response = await http.get(Uri.parse(urlLtc));
    jsonData = jsonDecode(response.body);
    var priceLtc = jsonData['rate'];

    setState(() {
      btc = priceBtc.toStringAsFixed(0);
      eth = priceEth.toStringAsFixed(0);
      ltc = priceLtc.toStringAsFixed(0);
      currencySelected = currency;
      //currencySymbol = symbol;
    });
    //return response;
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });

        print(selectedCurrency);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItem = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItem.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        getPrice(currenciesList[selectedIndex]);
        //print(currenciesList[selectedIndex]);
      },
      children: pickerItem,
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
          Padding(
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
                  '1 BTC = $btc $currencySelected', //rate
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
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
                  '1 ETH = $eth $currencySelected', //rate
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
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
                  '1 LTC = $ltc $currencySelected', //rate
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPicker(),
            //Platform.isIOS ? androidDropDown() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}
