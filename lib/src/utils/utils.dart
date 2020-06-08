import 'package:flutter/material.dart';

bool isNumber(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void showAlert(BuildContext ctx, String message) {
  showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Información incorrecta'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Ok'))
          ],
        );
      });
}
