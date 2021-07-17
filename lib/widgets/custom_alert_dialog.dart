import 'package:flutter/material.dart';
import 'package:just_do_it/widgets/scale_widget.dart';

class CustomAlertDialog extends StatelessWidget {
  final String content;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String snackBarText;
  final BuildContext mainContext;
  final Function() func;
  final Color yesColor;
  final Color noColor;
  final Color snackBarColor;
  const CustomAlertDialog({
    Key? key,
    required this.content,
    required this.scaffoldKey,
    required this.snackBarText,
    required this.mainContext,
    required this.func,
    this.yesColor = const Color(0xFFD50000),
    this.noColor = Colors.blue,
    this.snackBarColor = const Color(0xFFD50000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleWidget(
      child: AlertDialog(
        title: Text('Attention!'),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                func();
                // ignore: deprecated_member_use
                scaffoldKey.currentState!.showSnackBar(
                  SnackBar(
                    backgroundColor: snackBarColor,
                    duration: Duration(seconds: 2),
                    content: Text(snackBarText),
                  ),
                );

                Navigator.of(mainContext).pop();
              },
              child: Text(
                'Yes',
                style: TextStyle(color: yesColor),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(mainContext).pop();
              },
              child: Text(
                'No',
                style: TextStyle(color: noColor),
              ))
        ],
      ),
    );
  }
}
