import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/constants/colors.dart';

class SrcBar extends StatefulWidget {
  const SrcBar({super.key});

  @override
  State<SrcBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SrcBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HexColor(grayComponentBackground)),
                  borderRadius: BorderRadius.circular(70)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: HexColor(grayComponentBackground)),
                  borderRadius: BorderRadius.circular(70)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor(mainColorLight))),
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: HexColor(mainColorLight),
              hintText: "Hisse veya kripto para aratın...",
            ),
            cursorColor: HexColor(mainColorDark),
            autocorrect: true,
          ),
        ),
      ],
    );
  }
}
