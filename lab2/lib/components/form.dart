import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:developer' as developer;
import 'package:provider/provider.dart';
import '../main.dart';

class MyForm extends StatefulWidget {
  MyForm({Key key}) : super(key: key);

  @override
  _MyForm createState() => _MyForm();
}

class _MyForm extends State<MyForm> {
  final formKey = new GlobalKey<FormState>();
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final MaskedTextController _cvvController =
      MaskedTextController(mask: '0000');

  final cvvFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(onCardNumberChange);
    _cvvController.addListener(onCVVChange);
    cvvFocusNode.addListener(onCVVFocusChange);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    cvvFocusNode.dispose();
    super.dispose();
  }

  void onCardNumberChange() {
    Provider.of<Data>(context, listen: false)
        .updateCardNumber(_cardNumberController.text);
  }

  void onCVVChange() {
    Provider.of<Data>(context, listen: false).updateCVV(_cvvController.text);
  }

  void onCVVFocusChange() {
    Provider.of<Data>(context, listen: false)
        .updateShowBack(cvvFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final cardNumberField = TextFormField(
      controller: _cardNumberController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Card number',
        hintText: 'xxxx xxxx xxxx xxxx',
      ),
    );

    final cardNameField = TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Card name',
        hintText: '',
      ),
      onChanged: (String newCardName) {
        Provider.of<Data>(context, listen: false).updateCardName(newCardName);
      },
    );

    final monthField = DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(17.0),
        labelText: 'Month',
        border: OutlineInputBorder(),
      ),
      value: Provider.of<Data>(context).expirationMonth != ""
          ? Provider.of<Data>(context).expirationMonth
          : null,
      onChanged: (String newMonth) {
        Provider.of<Data>(context, listen: false)
            .updateExpirationMonth(newMonth);
      },
      items: [
        for (var i = 1; i <= 12; i += 1) (i < 10 ? "0" : "") + i.toString()
      ].map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            child: (Text(value)),
          ),
        );
      }).toList(),
    );

    final yearField = DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(17.0),
        labelText: 'Year',
        border: OutlineInputBorder(),
      ),
      value: Provider.of<Data>(context).expirationYear != ""
          ? Provider.of<Data>(context).expirationYear
          : null,
      onChanged: (String newYear) {
        Provider.of<Data>(context, listen: false).updateExpirationYear(newYear);
      },
      items: [for (var i = 2020; i <= 2030; i += 1) i.toString()].map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            child: (Text(value)),
          ),
        );
      }).toList(),
    );

    final cardCVVField = TextFormField(
      focusNode: cvvFocusNode,
      controller: _cvvController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'CVV',
      ),
    );

    final submitButton = ElevatedButton(
      child: Text(
        "Submit",
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 17,
          letterSpacing: 1.7,
        ),
      ),
      onPressed: () {},
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: cardNumberField,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: cardNameField,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 10,
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: monthField,
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: yearField,
                  ),
                ),
                // Spacer(flex: 1),
                Flexible(
                  flex: 7,
                  child: cardCVVField,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10.0),
            height: 55.0,
            child: submitButton,
          ),
        ],
      ),
    );
  }
}
