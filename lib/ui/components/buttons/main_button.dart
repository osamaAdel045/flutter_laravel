import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width ;
  final TextAlign? textAlign ;
  final String text;
  final double textSize ;
  final FontWeight fontWeight ;
  final EdgeInsetsGeometry padding ;
  final EdgeInsetsGeometry margin ;
  final Color backgroundColor ;
  final Color overlayColor ;
  final Color textColor ;

  const MainButton({
    Key? key,
    required this.text,
    this.width= double.maxFinite,
    this.textAlign,
    this.backgroundColor= Colors.green,
    this.overlayColor= Colors.grey,
    this.textColor= Colors.white,
    this.textSize= 16,
    this.fontWeight= FontWeight.w600,
    this.padding= const  EdgeInsets.all(8),
    this.margin= const  EdgeInsets.all(0),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          overlayColor: MaterialStateProperty.all(overlayColor),
        ),
        onPressed: onPressed,
        child: Container(
          width: textAlign!= null? double.maxFinite:null,
          padding: padding,
          child: Text(
            text,
            textAlign: textAlign ,
            style: TextStyle(color: textColor, fontSize: textSize, fontWeight: fontWeight ),
          ),
        ),
      ),
    );
  }
}
