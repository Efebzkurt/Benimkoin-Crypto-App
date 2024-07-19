import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/constants/colors.dart';

class DestekScreen extends StatefulWidget {
  const DestekScreen({super.key});

  @override
  State<DestekScreen> createState() => _DestekScreenState();
}

class _DestekScreenState extends State<DestekScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Destek ve Geribildirim',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              'Söyleyeceklerin Önemli!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
          ),
          //Mail Image
          SizedBox(
              height: deviceHeight / 5,
              child: Image.asset("lib/assets/images/destekgeribildirim.png")),
          //Texts
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text1,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              text2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),
          ),

          SizedBox(
              height: deviceHeight / 5,
              child: Image.asset("lib/assets/images/benimkoinlogo2.png")),
        ])),
      )),
    );
  }

  String text1 =
      'Uygulama hakkında görüş, öneri ve geribildirimini lütfen Play Store yorumlarına ilet.';
  String text2 =
      ' Geribildirimin kesinlikle okunacak ve geliştirme yapılırken göz önüne alınacaktır.';
}
