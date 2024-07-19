import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:benimkoin/components/selectionbox/selectionboxdata2.dart';

class SelectionBox2 extends StatefulWidget {
  const SelectionBox2({super.key});

  @override
  State<SelectionBox2> createState() => _SelectionBox2State();
}

class _SelectionBox2State extends State<SelectionBox2> {
  SelectionBox2Data selectedData = SelectionBox2Data.ozet;

  Color textColor1 = HexColor(white);
  Color textColor2 = HexColor(grayComponentText);

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: CupertinoSlidingSegmentedControl<SelectionBox2Data>(
        backgroundColor: HexColor(grayComponentBackground),
        thumbColor: HexColor(mainColorLight),
        groupValue: selectedData,
        onValueChanged: (SelectionBox2Data? value) {
          if (value != null) {
            setState(() {
              selectedData = value;
            });
          }
          if (value == SelectionBox2Data.ozet) {
            setState(() {
              textColor1 = HexColor(white);
              textColor2 = HexColor(grayComponentText);
            });
          } else if (value == SelectionBox2Data.ayrintili) {
            setState(() {
              textColor2 = HexColor(white);
              textColor1 = HexColor(grayComponentText);
            });
          }
        },
        children: <SelectionBox2Data, Widget>{
          SelectionBox2Data.ozet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Özet",
              style: TextStyle(color: textColor1, fontWeight: FontWeight.bold),
            ),
          ),
          SelectionBox2Data.ayrintili: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Ayrintili",
              style: TextStyle(color: textColor2, fontWeight: FontWeight.bold),
            ),
          ),
        },
      ),
    );
  }
}
