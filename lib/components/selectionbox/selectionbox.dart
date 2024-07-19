import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

enum SelectionBoxDataTime { time1, time2, time3, time4, time5, all }

class SelectionBox extends StatefulWidget {
  final ValueChanged<SelectionBoxDataTime> onSelectionChanged;

  const SelectionBox({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<SelectionBox> createState() => _SelectionBoxState();
}

class _SelectionBoxState extends State<SelectionBox> {
  SelectionBoxDataTime _selectedTime = SelectionBoxDataTime.time1;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: CupertinoSlidingSegmentedControl<SelectionBoxDataTime>(
        backgroundColor: HexColor('#E0E0E0'),
        thumbColor: HexColor('#FFFFFF'),
        groupValue: _selectedTime,
        onValueChanged: (SelectionBoxDataTime? value) {
          if (value != null) {
            setState(() {
              _selectedTime = value;
              widget.onSelectionChanged(value);
            });
          }
        },
        children: const <SelectionBoxDataTime, Widget>{
          SelectionBoxDataTime.time1: Text(
            "24s",
            style: TextStyle(color: CupertinoColors.black),
          ),
          SelectionBoxDataTime.time2: Text(
            "7g",
            style: TextStyle(color: CupertinoColors.black),
          ),
          SelectionBoxDataTime.time3: Text(
            "30g",
            style: TextStyle(color: CupertinoColors.black),
          ),
          SelectionBoxDataTime.time4: Text(
            "90g",
            style: TextStyle(color: CupertinoColors.black),
          ),
          SelectionBoxDataTime.time5: Text(
            "1 yıl",
            style: TextStyle(color: CupertinoColors.black),
          ),
          SelectionBoxDataTime.all: Text(
            "Tümü",
            style: TextStyle(color: CupertinoColors.black),
          ),
        },
      ),
    );
  }
}
