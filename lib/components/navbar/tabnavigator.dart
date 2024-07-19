import 'package:flutter/material.dart';
import 'package:benimkoin/screens/genelbakis_screen.dart';
import 'package:benimkoin/screens/hedef_screen.dart';
import 'package:benimkoin/screens/islemeklecategories/addcrypto/islemekle_crypto.dart';

import 'package:benimkoin/screens/portfoyum_screen.dart';
import 'package:benimkoin/screens/son_screen.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({super.key, this.tabItem, required this.navigatorkey});
  final String? tabItem;
  final GlobalKey<NavigatorState> navigatorkey;
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "GenelBakis") {
      child = const GenelBakisScreen();
    } else if (tabItem == "Portfoyum") {
      child = const PortfoyumScreen();
    } else if (tabItem == "IslemEkle") {
      child = const IslemEkleCrypto();
    } else if (tabItem == "Hedef") {
      child = const HedefScreen();
    } else if (tabItem == "SonScreen") {
      child = const SonScreen();
    } else {
      child = const GenelBakisScreen();
    }
    return Navigator(
      key: navigatorkey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
