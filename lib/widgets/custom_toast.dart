import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String toastText;
  const CustomToast({Key? key, required this.toastText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.yellowAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              toastText,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
