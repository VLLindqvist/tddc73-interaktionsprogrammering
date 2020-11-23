import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class Back extends StatefulWidget {
  Back({Key key}) : super(key: key);

  @override
  BackState createState() => BackState();
}

class BackState extends State<Back> {
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
    final cvvText = Container();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          color: Colors.black87,
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'CVV',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    padding: EdgeInsets.all(5.0),
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        for (int i = 0;
                            i < Provider.of<Data>(context).cvv.length;
                            i++)
                          Text("*"),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/visa.png',
                      scale: 2.4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
