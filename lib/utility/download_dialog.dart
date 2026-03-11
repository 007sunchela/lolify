import 'package:flutter/material.dart';

void showDownloadSuccessDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: colorScheme.onPrimary),
            SizedBox(width: 10),
            Text(
              'Скачивание мема',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ],
        ),
        content: Text(
          'Мем успешно скачан!',
          style: TextStyle(fontSize: 16, color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.surface,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Закрыть',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      );
    },
  );
}
