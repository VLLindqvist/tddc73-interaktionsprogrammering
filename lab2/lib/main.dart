import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/form.dart';
import 'components/creditCard/creditCard.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 2',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lab 2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return ChangeNotifierProvider<Data>(
      create: (context) => new Data(),
      child: Container(
        color: Colors.blueGrey[50],
        child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.only(top: 30.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    child: CreditCard(),
                  ),
                  Card(
                    margin: EdgeInsets.all(16),
                    child: MyForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Data extends ChangeNotifier {
  String cardName = "",
      cardNumber = "",
      expirationMonth = "",
      expirationYear = "",
      cvv = "",
      imageSrc = "assets/images/visa.png";
  bool showBack = false;

  void updateCardName(String input) {
    cardName = input;
    notifyListeners();
  }

  void updateCardNumber(String input) {
    cardNumber = input;
    updateImageSrc();
    notifyListeners();
  }

  void updateExpirationMonth(String input) {
    expirationMonth = input;
    notifyListeners();
  }

  void updateExpirationYear(String input) {
    expirationYear = input;
    notifyListeners();
  }

  void updateCVV(String input) {
    cvv = input;
    notifyListeners();
  }

  void updateShowBack(bool input) {
    showBack = input;
    notifyListeners();
  }

  void updateImageSrc() {
    if (cardNumber.length > 0) {
      final firstNumber = cardNumber[0];

      if (firstNumber == "4") {
        imageSrc = "assets/images/visa.png";
      } else if (firstNumber == "5") {
        imageSrc = 'assets/images/mastercard.png';
      } else if (firstNumber == "6") {
        imageSrc = 'assets/images/discover.png';
      } else if (firstNumber == "3") {
        if (cardNumber.length > 1) {
          final secondNumber = cardNumber[1];

          if (secondNumber == "4" || secondNumber == "7") {
            imageSrc = 'assets/images/amex.png';
          } else if (secondNumber == "0" ||
              secondNumber == "6" ||
              secondNumber == "8") {
            imageSrc = 'assets/images/dinersclub.png';
          }
        }
      }
    }
  }
}
