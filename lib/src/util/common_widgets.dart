import 'package:flutter/material.dart';

snackBarShow(BuildContext context, String displayString) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(displayString),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

//
InputDecoration getTextFieldDecoration(
    context, labelStr, hintStr, prefixicon, suffixicon, errorStr) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(12),
    filled: true,
    labelText: labelStr,
    hintText: hintStr,
    labelStyle: Theme.of(context).textTheme.caption,
    hintStyle: Theme.of(context).textTheme.caption,
    counterStyle: Theme.of(context).textTheme.caption,
    prefixIcon: prefixicon != null
        ? Icon(prefixicon, color: Theme.of(context).focusColor)
        : null,
    border: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).focusColor)),
    enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
    errorText: errorStr,
    suffixIcon: suffixicon != null
        ? Icon(suffixicon, color: Theme.of(context).focusColor)
        : null,
  );
}
