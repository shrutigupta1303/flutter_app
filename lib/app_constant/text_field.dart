import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  Key key;
  final TextInputType inputType;
  final TextEditingController controller;
  final double width;
  final EdgeInsetsGeometry margin;
  final String newHintText;
  final FontWeight newFontWeight;
  final Widget newSuffixIcon;
  final double borderRadius;
  final bool enabled,
      cursorEnabled,
      readOnlyEnabled,
      suffixIconPresent;
  final Function onChanged,
      onSuffixIconClicked,
      onSubmitted;

  final Function onClicked;
  final List<TextInputFormatter> newTextInputFormatter;
  final BoxDecoration boxDecoration;
  final EdgeInsets padding;
  final bool autoFocus;
  final TextInputAction textInputAction;
  final Color backGroundColor;
  final Color newFontColor;
  double textSize = 17;

  CustomTextField(
      {this.labelText,
        this.inputType = TextInputType.text,
        this.width,
        this.margin = const EdgeInsets.all(15.0),
        this.controller,
        this.newFontWeight = FontWeight.normal,
        this.newFontColor = Colors.grey,
        this.newHintText,
        this.newSuffixIcon,
        this.suffixIconPresent = false,
        this.borderRadius,
        this.enabled,
        this.cursorEnabled,
        this.onChanged,
        this.newTextInputFormatter,
        this.boxDecoration,
        this.onSuffixIconClicked,
        this.padding,
        this.readOnlyEnabled = false,
        this.autoFocus = false,
        this.onSubmitted,
        this.textInputAction,
        this.onClicked,
        this.key,
        this.textSize,
        this.backGroundColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: margin,
      width: width,
      padding: padding,
      height: 50,
      decoration: boxDecoration,
      child: TextField(
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        autofocus: autoFocus,
        controller: controller,
        keyboardType: inputType,
        inputFormatters: newTextInputFormatter,
        cursorColor: Colors.grey,
        showCursor: cursorEnabled,
        readOnly: readOnlyEnabled,
        onChanged: onChanged,
        enabled: enabled,
        onTap: onClicked,
        style: TextStyle(
          fontWeight: newFontWeight,
          color: newFontColor,
          fontSize: 15,
        ),
        decoration: InputDecoration(

            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                )
            ),
            filled: true,
            fillColor: backGroundColor,
            //  labelText: labelText,
            suffixIcon: suffixIconPresent
                ? IconButton(
              padding: EdgeInsets.all(4),
              icon: newSuffixIcon,
              iconSize: 20,
              disabledColor: Colors.blue,
              onPressed: onSuffixIconClicked,
            )
                : null,
            hintText:
            newHintText,
            hintStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14),
            // focusColor: Colors.white,
            errorStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            labelStyle: TextStyle(
                fontSize: textSize,
                color: Colors.grey,
                fontWeight: FontWeight.normal)),
      ),
    );
  }
}
