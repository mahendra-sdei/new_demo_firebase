import 'package:flutter/material.dart';
import 'package:new_demo_firebase/utils/constants.dart';

class IssueTicketInputDecoration extends InputDecoration {
  IssueTicketInputDecoration({
     String labelText,
    String hintText = '',
     Icon suffixIcon,
    EdgeInsets contentPadding = const EdgeInsets.all(16),
  }) : super(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon, alignLabelWithHint: true,
          contentPadding: contentPadding,
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Colors.black45,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Color(0xFFDCDCDC),
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Color(0xFFDCDCDC),
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          // hintStyle: TextStyle(color: Colors.grey),
        );
}
