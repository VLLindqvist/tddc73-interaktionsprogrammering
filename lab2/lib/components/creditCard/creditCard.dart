import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'frontside.dart';
import 'backside.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class CreditCard extends StatefulWidget {
  CreditCard({Key key}) : super(key: key);

  @override
  CreditCardState createState() => CreditCardState();
}

class CreditCardState extends State<CreditCard>
    with SingleTickerProviderStateMixin {
  AnimationController _cardAnimationController;
  Animation<double> _cardAnimation;
  AnimationStatus _cardAnimationStatus = AnimationStatus.dismissed;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _cardAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _cardAnimation =
        Tween<double>(end: 1, begin: 0).animate(_cardAnimationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            _cardAnimationStatus = status;
          });
  }

  @override
  void dispose() {
    // _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showBackFromProvider = Provider.of<Data>(context).showBack;

    if (showBackFromProvider != _showBack) {
      if (_cardAnimationStatus == AnimationStatus.dismissed) {
        _cardAnimationController.forward();
      } else {
        _cardAnimationController.reverse();
      }
      setState(() {
        _showBack = showBackFromProvider;
      });
    }

    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateY(pi * _cardAnimation.value),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/14.jpeg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 10.0),
              blurRadius: 15,
            )
          ],
        ),
        child: Card(
          child: _cardAnimation.value >= 0.5
              ? Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(-pi),
                  alignment: FractionalOffset.center,
                  child: Back(),
                )
              : Front(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          elevation: 10,
          margin: EdgeInsets.all(0.0),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
