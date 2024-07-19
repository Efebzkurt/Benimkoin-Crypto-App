import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/components/navbar/tabnavigator.dart';
import 'package:benimkoin/constants/colors.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String _currentPage = 'GenelBakis';
  List<String> pageKeys = [
    "GenelBakis",
    "Portfoyum",
    "IslemEkle",
    "Hedef",
    "SonScreen"
  ];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "GenelBakis": GlobalKey<NavigatorState>(),
    "Portfoyum": GlobalKey<NavigatorState>(),
    "IslemEkle": GlobalKey<NavigatorState>(),
    "Hedef": GlobalKey<NavigatorState>(),
    "SonScreen": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;
  double iconsize = 45;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
          if (isFirstRouteInCurrentTab) {
            if (_currentPage != "GenelBakis") {
              _selectTab("GenelBakis", 1);

              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator("GenelBakis"),
              _buildOffstageNavigator("Portfoyum"),
              _buildOffstageNavigator("IslemEkle"),
              _buildOffstageNavigator("Hedef"),
              _buildOffstageNavigator("SonScreen"),
            ],
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: BottomNavigationBar(
                enableFeedback: false,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                        size: iconsize,
                        color: HexColor(grayComponentText),
                        const AssetImage(
                          "lib/assets/images/genelbakislogo.png",
                        ),
                      ),
                      label: 'Genel Bakış',
                      activeIcon: ImageIcon(
                          size: iconsize,
                          color: HexColor(mainColorMid),
                          const AssetImage(
                              "lib/assets/images/genelbakistiklogo.png"))),
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                        size: iconsize,
                        color: HexColor(grayComponentText),
                        const AssetImage("lib/assets/images/portfoyumlogo.png"),
                      ),
                      label: 'Portföyüm',
                      activeIcon: ImageIcon(
                          size: iconsize,
                          color: HexColor(mainColorMid),
                          const AssetImage(
                              "lib/assets/images/portfoyumtiklogo.png"))),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: ImageIcon(
                          size: iconsize + 5,
                          color: HexColor(grayComponentText),
                          const AssetImage(
                              "lib/assets/images/islemeklelogo.png"),
                        ),
                      ),
                      label: '',
                      activeIcon: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: ImageIcon(
                            size: iconsize + 5,
                            color: HexColor(mainColorMid),
                            const AssetImage(
                                "lib/assets/images/islemeklelogo.png")),
                      )),
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                        size: iconsize,
                        color: HexColor(grayComponentText),
                        const AssetImage("lib/assets/images/hedeflogo.png"),
                      ),
                      label: 'İşlemlerim',
                      activeIcon: ImageIcon(
                          size: iconsize,
                          color: HexColor(mainColorMid),
                          const AssetImage(
                              "lib/assets/images/hedeftiklogo.png"))),
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                        size: iconsize,
                        color: HexColor(mainColorMid),
                        const AssetImage("lib/assets/images/basitlogo.png"),
                      ),
                      label: 'Ayarlar',
                      activeIcon: ImageIcon(
                          color: HexColor(mainColorDark),
                          size: iconsize,
                          const AssetImage(
                              "lib/assets/images/basitlogo2.png"))),
                ],
                iconSize: 50,
                onTap: (int index) {
                  _selectTab(pageKeys[index], index);
                },
                currentIndex: _selectedIndex,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                unselectedItemColor: HexColor(grayComponentText),
                showUnselectedLabels: true,
                selectedLabelStyle: TextStyle(
                    color: HexColor(grayComponentText),
                    fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(
                    color: HexColor(grayComponentText),
                    fontWeight: FontWeight.w600)),
          ),
        ));
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorkey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }
}
