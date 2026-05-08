import 'package:bg_tools/core/consts.dart';
import 'package:flutter/material.dart';

Widget buildLoadingScreen() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(getLoadingMsg()),
      ],
    ),
  );
}
