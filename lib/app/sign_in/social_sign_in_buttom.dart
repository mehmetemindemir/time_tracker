import 'package:flutter/material.dart';
import 'package:time_tracker/common_widget/custom_raised_button.dart';

class SocialSignInButtom extends CustomRaisedButtom{
  SocialSignInButtom({
   @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
    double borderRadius,
    double height,
    @required String icon
  }):
      assert(null!=icon),
      assert(null!=text),
        super(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(icon,),
          Text(text,style: TextStyle(fontSize: 15.0,color: textColor),),
          Opacity(
            opacity: 0.0,
            child: Image.asset(icon),
          )
        ],
      ),
      color:color,
      onPressed:onPressed,
      borderRadius:borderRadius,
      height:height
  );
}