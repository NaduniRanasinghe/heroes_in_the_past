import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Waiting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[900],
      child: Center(
        child: SpinKitCircle(
          color: Colors.orange,
          size: 50.0,
        )
      ),
    );
  }
}
