import 'package:flutter/material.dart';

import 'package:bg_tools/core/consts/export.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
}
