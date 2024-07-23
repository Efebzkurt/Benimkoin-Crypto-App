import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:benimkoin/components/charts/linechart/linechart.dart';
import 'package:benimkoin/components/circularprogress/circularprogress.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/components/selectionbox/selectionbox.dart';
import 'package:benimkoin/google_ads/google_ads.dart';
import 'package:benimkoin/provider/portfolio_provider.dart';
import 'package:provider/provider.dart';

class GenelBakisScreen extends StatefulWidget {
  const GenelBakisScreen({super.key});

  @override
  State<GenelBakisScreen> createState() => _GenelBakisScreenState();
}

class _GenelBakisScreenState extends State<GenelBakisScreen> {
  final GoogleAds _googleAds = GoogleAds();
  SelectionBoxDataTime _selectedTime = SelectionBoxDataTime.time1;
  Map<String, dynamic>? _coinData;
  bool _isDataLoaded = false;
  bool _hasError = false;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _googleAds.loadBannerAd();
    Provider.of<PortfolioProvider>(context, listen: false)
        .fetchHistoricalData(_selectedTime)
        .then((_) {
      _fetchCoinData();
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: _googleAds.bannerAd == null
                    ? const CircularProgress()
                    : SizedBox(
                        width: _googleAds.bannerAd!.size.width.toDouble(),
                        height: _googleAds.bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _googleAds.bannerAd!),
                      )),

            genelBakisText(),

            //Portfolio Value
            Expanded(
              flex: 4,
              child: showPortfolioValue(),
            ),
            //Selectionbox
            Expanded(
              flex: 3,
              child: selectionBox(),
            ),
            //Grafik yazi
            Expanded(
              flex: 2,
              child: btcGraphText(),
            ),
            //Bitcoin Chart
            Expanded(
              flex: 15,
              child: btcChart(),
            ),
            //Baslik Text
            Expanded(flex: 6, child: lastDayPerformanceTitle()),
            //Kutucuk Üstü Text
            Expanded(
              flex: 2,
              child: aboveBoxTitle(),
            ),
            //Bilgi kutucukları
            Expanded(
              flex: 10,
              child: _hasError
                  ? const Center(child: CircularProgress())
                  : _coinData == null
                      ? const Center(child: CircularProgress())
                      : infoBoxes(),
            ),
          ],
        ),
      ),
    );
  }

  Padding infoBoxes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCoinInfo(_coinData!['bitcoin'], 'Bitcoin'),
            _buildCoinInfo(_coinData!['topGainer'], 'En Çok Yükselen'),
            _buildCoinInfo(_coinData!['topLoser'], 'En Çok Düşen'),
          ],
        ),
      ),
    );
  }

  Row aboveBoxTitle() {
    return const Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              'Bitcoin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'En çok yükselen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'En çok düşen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Align lastDayPerformanceTitle() {
    return const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 40, 0, 0),
          child: Text(
            'Son 24 Saatte Fiyat Hareketleri',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ));
  }

  Align btcChart() {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
            child: PortfolioChart(selectedTime: _selectedTime)),
      ),
    );
  }

  Align btcGraphText() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text(
              'Bitcoin Grafiği (\$)',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: HexColor(black1)),
            )));
  }

  Align selectionBox() {
    return Align(
      alignment: Alignment.topCenter,
      child: SelectionBox(onSelectionChanged: _onSelectionChanged),
    );
  }

  Padding showPortfolioValue() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Consumer<PortfolioProvider>(
          builder: (context, portfolioProvider, child) {
            final transactions = portfolioProvider.allTransactions;
            final totalValue = portfolioProvider.totalValue;
            return transactions.isNotEmpty && totalValue == 0
                ? const CircularProgress()
                : Text(
                    '₺${totalValue.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: HexColor(black1),
                      fontSize: 35,
                    ),
                  );
          },
        ),
      ),
    );
  }

  Padding genelBakisText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Genel Bakış",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: HexColor(black1),
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  void _onSelectionChanged(SelectionBoxDataTime value) {
    setState(() {
      _selectedTime = value;
    });
    Provider.of<PortfolioProvider>(context, listen: false)
        .fetchHistoricalData(_selectedTime);
  }

  Widget _buildCoinInfo(Map<String, dynamic> coin, String label) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black)),
          width: deviceWidth / 3.5,
          height: deviceHeight / 7,
          child: Column(
            children: [
              Row(
                children: [
                  //Image
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.network(
                        coin['image'],
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  //Symbol
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: Text(
                          '${coin['symbol'].toUpperCase()}',
                          style: TextStyle(
                              color: HexColor(grayComponentText),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  //Price
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '\$${coin['current_price']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ),
                  //Price percentage change
                  Text(
                      '${coin['price_change_percentage_24h'].toStringAsFixed(2)}%',
                      style: TextStyle(
                          color: coin['price_change_percentage_24h'] >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 17)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _fetchCoinData() async {
    if (_isDataLoaded) return;

    try {
      final data = await Provider.of<PortfolioProvider>(context, listen: false)
          .fetchCoinData();
      setState(() {
        _coinData = data;
        _isDataLoaded = true;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });

      if (e.toString().contains('429')) {
        _retryTimer = Timer(const Duration(seconds: 30), () {
          _fetchCoinData();
        });
      }
    }
  }
}
