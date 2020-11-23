import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class Front extends StatefulWidget {
  Front({Key key}) : super(key: key);

  @override
  FrontState createState() => FrontState();
}

class FrontState extends State<Front> {
  // final formKey = new GlobalKey<FormState>();

  // @override
  // void initState() {
  //   // super.initState();
  //   // _cardNumberController.addListener(_onCardNumberChange);
  // }

  // @override
  // void dispose() {
  //   // _cardNumberController.dispose();
  //   // super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> transFormText(String cardNumber) {
      // String str = Provider.of<Data>(context).cardNumber;
      cardNumber = cardNumber != "" ? cardNumber.replaceAll(' ', '') : "";
      List<Widget> res = [];

      for (var i = 0; i < 16; i++) {
        res.add(
          Container(
            width: MediaQuery.of(context).size.width / 27,
            margin: i % 4 == 0 && i != 0
                ? EdgeInsets.only(left: 15.0)
                : EdgeInsets.only(left: 0.0),
            child: Text(
              i > cardNumber.length - 1 ? "#" : cardNumber[i],
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }

      return res;
    }

    final cardNumberText = Row(
      children: <Widget>[
        Container(
          child: Consumer<Data>(
            builder: (context, data, child) {
              return Row(
                children: transFormText(data.cardNumber),
              );
            },
          ),
          padding: EdgeInsets.all(10.0),
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.white),
          // ),
        ),
      ],
    );

    final cardHolderText = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Card Holder',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
          Text(
            Provider.of<Data>(context).cardName != ""
                ? Provider.of<Data>(context).cardName
                : "FULL NAME",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );

    final expiresText = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            'Expires',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
          Text(
            (Provider.of<Data>(context).expirationMonth != ""
                    ? Provider.of<Data>(context).expirationMonth
                    : "MM") +
                "/" +
                (Provider.of<Data>(context).expirationYear != ""
                    ? Provider.of<Data>(context).expirationYear.substring(2)
                    : "YY"),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                'assets/images/chip.png',
                scale: 1.9,
              ),
              Image.asset(
                'assets/images/visa.png',
                scale: 2.4,
              ),
            ],
          ),
          cardNumberText,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              cardHolderText,
              expiresText,
            ],
          ),
        ],
      ),
    );
  }
}
