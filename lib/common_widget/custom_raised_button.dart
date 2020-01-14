import 'package:flutter/material.dart';

class CustomRaisedButtom extends StatelessWidget {
  CustomRaisedButtom({
    this.child,
    this.color,
    this.borderRadius:2.0,
    this.onPressed,
    this.height:50.0
  });
 final Widget child;
 final Color color;
 final double borderRadius;
 final VoidCallback onPressed;
 final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child:child,
        onPressed: onPressed,
        disabledColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
        ),
        color: color,
      ),
    );
  }
}
