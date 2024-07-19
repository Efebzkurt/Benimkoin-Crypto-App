import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/components/circularprogress/circularprogress.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/data/coin_service.dart';
import 'package:benimkoin/screens/islemeklecategories/addcrypto/addcrypto_screen.dart';

class IslemEkleCrypto extends StatefulWidget {
  const IslemEkleCrypto({super.key});
  @override
  State<IslemEkleCrypto> createState() => _IslemEkleCryptoState();
}

class _IslemEkleCryptoState extends State<IslemEkleCrypto> {
  final TextEditingController _searchController = TextEditingController();
  List _allCoins = [];
  List _coinsMarkets = [];
  List _searchResults = [];
  Timer? _debounce;
  Timer? _retryTimer;
  final CoinService _coinService = CoinService();
  bool _isDataLoaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _retryTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    if (_isDataLoaded) return; // Eğer veriler yüklendiyse tekrar yükleme

    try {
      final coinsMarkets = await _coinService.coinsbyMcap();
      final allCoins = await _coinService.allCoins();

      setState(() {
        _coinsMarkets = coinsMarkets;
        _allCoins = allCoins;
        _searchResults = List.from(_coinsMarkets);
        _isDataLoaded = true;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });

      if (e.toString().contains('429')) {
        _retryTimer = Timer(const Duration(seconds: 30), () {
          _fetchInitialData();
        });
      }
    }
  }

  void _searchCoins(String searchTerm) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchTerm.isEmpty) {
        setState(() {
          _searchResults = List.from(_coinsMarkets);
        });
        return;
      }

      setState(() {
        _searchResults = _allCoins
            .where((coin) =>
                coin['name']
                    .toLowerCase()
                    .startsWith(searchTerm.toLowerCase()) ||
                coin['symbol']
                    .toLowerCase()
                    .startsWith(searchTerm.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double deviceWidth = size.width;
    double deviceHeight = size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Kripto Para Ekle",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
          ),

          //Searchbar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
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
                hintText: "Kripto para aratın...",
              ),
              cursorColor: HexColor(mainColorDark),
              autocorrect: true,
              onChanged: (val) {
                _searchCoins(val);
              },
            ),
          ),

          //Crypto List
          //Error
          Expanded(
            flex: 10,
            child: _hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kripto paralar yükleniyor. Lütfen bekleyin...',
                          style: TextStyle(
                              color: HexColor(mainColorDark), fontSize: 15),
                        ),
                        const SizedBox(height: 20),
                        const CircularProgress(),
                      ],
                    ),
                  )
                //
                : _searchResults.isEmpty
                    ? const Expanded(child: Center(child: CircularProgress()))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final coin = _searchResults[index];
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                  height: deviceHeight / 15,
                                  child: coin == null
                                      ? const CircularProgress()
                                      : listTiles(coin, deviceWidth),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddCryptoScreen(
                                    coinSymbol: coin['symbol'],
                                    coinName: coin['name'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          )
        ])),
      ),
    );
  }

  Row listTiles(coin, double deviceWidth) {
    return Row(children: [
      if (coin.containsKey('market_cap_rank'))
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              coin['market_cap_rank'].toString(),
              style: const TextStyle(fontSize: 17),
            )),
      if (coin.containsKey('image'))
        Image.network(coin['image'], width: deviceWidth / 9),
      //Name
      Flexible(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Expanded(
              child: Text(
                coin['name'],
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ),
      //Symbol
      Flexible(
        child: Text(coin['symbol'].toString().toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: HexColor(grayComponentText),
                fontSize: 17)),
      ),
    ]);
  }
}
