import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:benimkoin/components/circularprogress/circularprogress.dart';
import 'package:benimkoin/components/selectionbox/selectionboxdata2.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/components/charts/linechart/indicator.dart';
import 'package:benimkoin/provider/portfolio_provider.dart';

class PortfoyumScreen extends StatefulWidget {
  const PortfoyumScreen({super.key});

  @override
  State<PortfoyumScreen> createState() => _PortfoyumScreenState();
}

class _PortfoyumScreenState extends State<PortfoyumScreen> {
  SelectionBox2Data selectedData = SelectionBox2Data.ozet;
  Color textColor1 = HexColor(white);
  Color textColor2 = HexColor(grayComponentText);
  List<PieChartSectionData> _pieChartSections = [];
  DateTime? _lastRefreshTime;

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
    final portfolioProvider =
        Provider.of<PortfolioProvider>(context, listen: false);
    portfolioProvider.loadAssets();
  }

  Future<void> _loadPortfolio() async {
    if (_lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!).inSeconds < 5) {
      _showRateLimitAlert();
      return;
    }

    _lastRefreshTime = DateTime.now();

    try {
      await Provider.of<PortfolioProvider>(context, listen: false)
          .calculateTotalValue();

      _generatePieChartSections();
    } catch (error) {
      if (error.toString().contains('429')) {
        _showRateLimitAlert();
        await Future.delayed(const Duration(seconds: 30));
        await _loadPortfolio();
      } else {
        print("Bir hata oluştu: $error");
      }
    }
  }

  void _showRateLimitAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor(mainColorMid),
          title: Center(
            child: Text(
              "Çok Fazla İstek",
              style: TextStyle(color: HexColor(white), fontSize: 20),
            ),
          ),
          content: Text("Lütfen biraz bekleyip tekrar deneyin",
              style: TextStyle(color: HexColor(white))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: SafeArea(
        child: Consumer<PortfolioProvider>(
          builder: (context, portfolioProvider, child) {
            final portfolio = portfolioProvider.portfolio;

            return Column(
              children: [
                // SELECTIONBOX
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: CupertinoSlidingSegmentedControl<SelectionBox2Data>(
                    backgroundColor: HexColor(grayComponentBackground),
                    thumbColor: HexColor(mainColorLight),
                    groupValue: selectedData,
                    onValueChanged: (SelectionBox2Data? value) {
                      if (value != null) {
                        setState(() {
                          selectedData = value;
                          _generatePieChartSections();
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Özet",
                          style: TextStyle(
                              color: textColor1, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SelectionBox2Data.ayrintili: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Ayrintili",
                          style: TextStyle(
                              color: textColor2, fontWeight: FontWeight.bold),
                        ),
                      ),
                    },
                  ),
                ),

                // PIECHART
                Expanded(
                  flex: 3,
                  child: portfolio.isEmpty
                      ? Center(
                          child: Image.asset(
                              "lib/assets/images/portfoybosgrafik.png"))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                child: PieChart(
                                  PieChartData(
                                    sections: _pieChartSections,
                                  ),
                                  swapAnimationDuration:
                                      const Duration(milliseconds: 400),
                                  swapAnimationCurve: Curves.easeOutBack,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // PIECHART DATA
                            Expanded(
                              flex: 2,
                              child: ListView(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _pieChartSections.map((section) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Indicator(
                                          color: section.color,
                                          text: section.title,
                                          isSquare: true,
                                          size: 16,
                                          textColor: HexColor(black),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                //BELOW PIECHART
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Consumer<PortfolioProvider>(
                      builder: (context, portfolioProvider, child) {
                        final portfolio = portfolioProvider.portfolio;
                        if (portfolio.isEmpty) {
                          return Center(
                              child: Image.asset(
                                  "lib/assets/images/portfoybosgrafik2.png"));
                        }
                        return Column(
                          children: [
                            // Header row
                            header(),
                            // Portfolio list
                            Expanded(
                              child: RefreshIndicator(
                                backgroundColor: HexColor(mainColorLight),
                                color: HexColor(white),
                                onRefresh: _loadPortfolio,
                                child: ListView.builder(
                                  itemCount: portfolio.length,
                                  itemBuilder: (context, index) {
                                    final asset = portfolio[index];
                                    final assetName = asset['name'].toString();
                                    final currentPrice =
                                        portfolioProvider.currentPrices[
                                                assetName.toLowerCase()] ??
                                            0.0;
                                    final totalValue = currentPrice *
                                        (asset['quantity'] as num);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            assetName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                                      '₺${currentPrice.toStringAsFixed(2)}'))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(asset['quantity']
                                                      .toStringAsFixed(2)))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                                      '₺${totalValue.toStringAsFixed(2)}'))),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Row header() {
    return const Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              'Varlıklar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Fiyat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Adet',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Toplam',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> colors = [
    HexColor(pieChart1),
    HexColor(pieChart2),
    HexColor(pieChart3),
    HexColor(pieChart4),
    HexColor(pieChart5),
    HexColor(pieChart6),
    HexColor(pieChart7),
    HexColor(pieChart8),
    HexColor(pieChart9),
    HexColor(pieChart10),
    HexColor(pieChart11),
    HexColor(pieChart12),
  ];
  void _generatePieChartSections() {
    final portfolioProvider =
        Provider.of<PortfolioProvider>(context, listen: false);
    final portfolio = portfolioProvider.portfolio;
    final currentPrices = portfolioProvider.currentPrices;
    final totalPortfolioValue = portfolioProvider.totalValue;

    Map<String, double> assetValues = {};

    for (var asset in portfolio) {
      final assetName = asset['name'].toString();
      final currentPrice = currentPrices[assetName.toLowerCase()] ?? 0.0;
      final totalValue = currentPrice * (asset['quantity'] as num);
      assetValues[assetName] = totalValue;
    }

    if (selectedData == SelectionBox2Data.ozet) {
      // Group assets with less than 5% of total value into "Others"
      const threshold = 0.05;
      double otherValuesTotal = 0.0;
      List<MapEntry<String, double>> significantAssets = [];

      assetValues.forEach((name, value) {
        if (value / totalPortfolioValue < threshold) {
          otherValuesTotal += value;
        } else {
          significantAssets.add(MapEntry(name, value));
        }
      });

      if (otherValuesTotal > 0) {
        significantAssets.add(MapEntry('Diğer', otherValuesTotal));
      }

      // Generate pie chart sections
      final List<PieChartSectionData> sections =
          significantAssets.asMap().entries.map((entry) {
        int index = entry.key;
        final assetEntry = entry.value;
        return PieChartSectionData(
          showTitle: false,
          value: assetEntry.value,
          title: assetEntry.key,
          color: assetEntry.key == 'Diğer'
              ? Colors.grey
              : colors[index % colors.length],
        );
      }).toList();

      setState(() {
        _pieChartSections = sections;
      });
    } else {
      // Show all assets
      final List<PieChartSectionData> sections =
          assetValues.entries.toList().asMap().entries.map((entry) {
        int index = entry.key;
        final assetEntry = entry.value;
        return PieChartSectionData(
          showTitle: false,
          value: assetEntry.value,
          title: assetEntry.key,
          color: assetEntry.key == 'Diğer'
              ? Colors.grey
              : colors[index % colors.length],
        );
      }).toList();

      setState(() {
        _pieChartSections = sections;
      });
    }
  }
}
