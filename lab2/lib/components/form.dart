import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:developer' as developer;

class MyForm extends StatefulWidget {
  MyForm({Key key}) : super(key: key);

  @override
  _MyForm createState() => _MyForm();
}

class _MyForm extends State<MyForm> {
  final formKey = new GlobalKey<FormState>();
  FocusNode _focusNode = new FocusNode();
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');

  String _cardName;
  int _cardNumber, _expirationMonth, _expirationYear, _cvv;

  @override
  void initState() {
    super.initState();
    // _cardNumberController.addListener(_onCardNumberChange);
    _focusNode.addListener(_onCVVFocusChange);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }

  void _onCardNumberChange() {
    developer.log(_cardNumberController.text);
    setState(() {
      _cardNumber = int.parse(_cardNumberController.text);
    });
  }

  void _onCVVFocusChange() {
    // developer.log('hej');
    // //Force updated once if focus changed
    // setState(() {});
  }

  void _handleCardNumberField(String val) {}

  @override
  Widget build(BuildContext context) {
    final cardNumberField = TextFormField(
      controller: _cardNumberController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Card number",
        hintText: 'xxxx xxxx xxxx xxxx',
      ),
    );

    final cardNameField = TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Card name",
        hintText: '',
      ),
    );

    final monthField = FormField<int>(
      builder: (FormFieldState<int> state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: (_expirationMonth != null ? 'Month' : ''),
            contentPadding: EdgeInsets.all(0.0),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<int>(
                value: _expirationMonth,
                onChanged: (int newValue) {
                  setState(() {
                    _expirationMonth = newValue;
                    state.didChange(newValue);
                  });
                },
                items: [for (var i = 1; i <= 12; i += 1) i].map((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Container(
                      child: (Text(value.toString())),
                      width: 70,
                    ),
                  );
                }).toList(),
                hint: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Month",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    final yearField = FormField<int>(
      builder: (FormFieldState<int> state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: (_expirationYear != null ? 'Year' : ''),
            contentPadding: EdgeInsets.all(0.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _expirationYear,
              onChanged: (int newValue) {
                setState(() {
                  _expirationMonth = newValue;
                  state.didChange(newValue);
                });
              },
              items: [for (var i = 2020; i <= 2030; i += 1) i].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: SizedBox(
                    child: (Text(value.toString())),
                    width: 70,
                  ),
                );
              }).toList(),
              hint: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Year",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    );

    final cardCVVField = TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "CVV",
        contentPadding: EdgeInsets.all(0.0),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          cardNumberField,
          cardNameField,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: monthField,
              ),
              Flexible(
                flex: 2,
                child: yearField,
              ),
              // Spacer(flex: 1),
              Flexible(
                flex: 1,
                child: cardCVVField,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
