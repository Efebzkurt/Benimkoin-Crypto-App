import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/components/circularprogress/circularprogress.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/google_ads/google_ads.dart';
import 'package:benimkoin/screens/islemeklecategories/addcrypto/addcrypto_screen.dart';
import 'package:benimkoin/screens/son_screens/destek_geribildirim.dart';
import 'package:benimkoin/screens/son_screens/kullanicisozlesmesi.dart';
import 'package:benimkoin/screens/son_screens/yasaluyari.dart';

class SonScreen extends StatefulWidget {
  const SonScreen({super.key});
  @override
  State<SonScreen> createState() => _SonScreenState();
}

class _SonScreenState extends State<SonScreen> {
  final GoogleAds _googleAds = GoogleAds();
  @override
  void initState() {
    super.initState();
    _googleAds.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double containerHeight = deviceHeight / 15;
    double leftPadding = 20;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
              flex: 1,
              child: _googleAds.bannerAd == null
                  ? const CircularProgress()
                  : SizedBox(
                      width: _googleAds.bannerAd!.size.width.toDouble(),
                      height: _googleAds.bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _googleAds.bannerAd!),
                    )),
          const Spacer(),
          Expanded(
            flex: 17,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Ayarlar',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: containerHeight,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: leftPadding),
                          child: Text('Karanlık Mod ', style: _textStyle())),
                      Expanded(
                          flex: 2,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.lock,
                                color: HexColor(mainColorDark),
                              ))),
                      Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Switch(
                                  inactiveThumbColor: HexColor(mainColorMid),
                                  activeColor: HexColor(mainColorMid),
                                  hoverColor: HexColor(mainColorDark),
                                  value: false,
                                  onChanged: (value) {},
                                ))),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                  child: Text(
                    'Destek',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                //Destek/Geribildirim
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DestekScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: containerHeight,
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: leftPadding),
                            child: Text('Destek/Geribildirim',
                                style: _textStyle())),
                        const Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child:
                                      Icon(Icons.arrow_forward_ios_rounded))),
                        )
                      ],
                    ),
                  ),
                ),

                //Hakkında Baslik
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                  child: Text(
                    'Hakkında',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                //Kullanici Sozlesmesi
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const KullaniciSozlesmesi(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: containerHeight,
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: leftPadding),
                            child: Text('Kullanıcı Sözleşmesi ve Yasal Uyarı',
                                style: _textStyle())),
                        const Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child:
                                      Icon(Icons.arrow_forward_ios_rounded))),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Divider divider() {
    return const Divider(
      indent: 20,
      endIndent: 20,
      height: 2,
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  }
}
