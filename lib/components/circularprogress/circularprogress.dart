import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/constants/colors.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: HexColor(mainColorLight),
      strokeWidth: 5,
    );
  }
}
