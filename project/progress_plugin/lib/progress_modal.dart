import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

export 'progress_modal.dart';

class ProgressModal extends StatefulWidget {
  ProgressModal({
    Key key,
    this.isLoading = true,
    this.labelColor = const Color(0xff1B2334),
    this.backgroundColor = const Color(0xFF000000),
    this.cardColor = const Color(0xFFFFFFFF),
    this.progressColor = const Color(0xFF82B1FF),
    this.progressBackground = const Color(0xFFFFFFFF),
    this.labelText,
  });
  final bool isLoading;
  final Color labelColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color progressColor;
  final Color progressBackground;
  final Text labelText;

  @override
  _ProgressModalState createState() => _ProgressModalState();
}

class _ProgressModalState extends State<ProgressModal> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading ? Container(
      color: widget.backgroundColor.withOpacity(0.5),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: widget.cardColor,
          ),
          margin: EdgeInsets.all(50),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
                    backgroundColor: widget.progressBackground,
                  ),
                ],
              ),
              widget.labelText != null ?
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    widget.labelText,
                    Padding(padding: EdgeInsets.only(top: 30)),
                  ],
                ):
                Row(
                  mainAxisSize: MainAxisSize.min,
                ),
            ],
          ),
        ),
      ),
    )
    :
    Container();
  }
}