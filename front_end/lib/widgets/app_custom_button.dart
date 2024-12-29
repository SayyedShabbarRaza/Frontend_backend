import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final Color? color, tcolor, borderColor;
  final VoidCallback function;
  const PrimaryButton({
    super.key,
    required this.text,
    this.height,
    this.width,
    this.color,
    this.tcolor,
    this.borderColor,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    final mheight = MediaQuery.of(context).size.height * .05;
    final mwidth = MediaQuery.of(context).size.width * .5;
    return InkWell(
      onTap: function,
      child: Container(
        height: height ?? mheight,
        width: width ?? mwidth,
        decoration: BoxDecoration(
            color: color ?? Colors.green,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: borderColor ?? Colors.black,
            )),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: tcolor ?? Colors.black,
                fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}
