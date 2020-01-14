import 'package:flutter/material.dart';
import 'package:time_tracker/common_widget/custom_raised_button.dart';

class SignInButtom extends CustomRaisedButtom{
  SignInButtom({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
    double borderRadius,
    double height,
}):     assert(null!=text),
        super(
    child: Text(text, style:TextStyle(color: textColor,fontSize: 15.0),),
    color:color,
    onPressed:onPressed,
    borderRadius:borderRadius,
    height:height
  );
}