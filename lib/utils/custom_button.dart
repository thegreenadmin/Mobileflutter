import 'package:flutter/material.dart';

import 'package:thegreenmall/utils/sizedbox_constants.dart';

import '../utils/constants.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  Function()? onTap;
  double? height;
  double? width;
  Widget? imageL;
  Widget? imageR;
  bool? iconL;
  bool? iconR;
  String? text;
  Color? textColor;
  Color? color;
  EdgeInsets? padding;
  EdgeInsets? margin;
  String? fontFamily;
  double? fontSize;
  double? borderRadius;
  FontWeight? fontWeight;
  Gradient? gradient;
  BoxBorder? border;

  CustomButton(
      {super.key,
      this.onTap,
      this.height,
      this.width,
      this.margin,
      this.text,
      this.padding,
      this.color,
      this.fontFamily,
      this.fontSize,
      this.borderRadius,
      this.fontWeight,
      this.iconL,
      this.iconR,
      this.imageL,
      this.imageR,
      this.textColor,
      this.gradient,
      this.border});

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: widget.padding,
          margin: widget.margin,
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
              gradient: widget.gradient,
              border: widget.border),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.iconL == true) ...[widget.imageL!, width10SizedBox],
              Flexible(
                child: DefaultTextStyle(
                  style: TextStyle(
                      color: widget.textColor,
                      fontFamily: widget.fontFamily,
                      fontSize: widget.fontSize,
                      letterSpacing: 0,
                      fontWeight: widget.fontWeight),
                  child: Text(
                    widget.text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: widget.textColor,
                        fontFamily: widget.fontFamily,
                        fontSize: widget.fontSize,
                        letterSpacing: 0,
                        fontWeight: widget.fontWeight),
                  ),
                ),
              ),
              if (widget.iconR == true) ...[widget.imageR!, width10SizedBox],
            ],
          ),
        ));
  }
}
