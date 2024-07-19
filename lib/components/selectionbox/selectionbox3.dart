import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/components/selectionbox/selectionbox3data.dart';

import 'package:flutter/cupertino.dart';

class SelectionBox3 extends StatefulWidget {
  const SelectionBox3({super.key});

  @override
  State<SelectionBox3> createState() => _SelectionBox3State();
}

class _SelectionBox3State extends State<SelectionBox3> {
  SelectionBox3Data selectedTime = SelectionBox3Data.al;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<SelectionBox3Data>(
      backgroundColor: HexColor(grayComponentBackground),
      thumbColor: HexColor(white),
      groupValue: selectedTime,
      onValueChanged: (SelectionBox3Data? value) {
        if (value != null) {
          setState(() {
            selectedTime = value;
          });
        }
      },
      children: <SelectionBox3Data, Widget>{
        SelectionBox3Data.al: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Satın Al",
              style: TextStyle(
                  color: HexColor(black),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            )),
        SelectionBox3Data.sat: Text(
          "Satış Yap",
          style: TextStyle(
            color: HexColor(black),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      },
    );
  }
}
