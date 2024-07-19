import 'package:benimkoin/provider/portfolio_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:benimkoin/components/circularprogress/circularprogress.dart';
import 'package:benimkoin/constants/colors.dart';
import 'package:benimkoin/google_ads/google_ads.dart';
import 'package:provider/provider.dart';

class HedefScreen extends StatefulWidget {
  const HedefScreen({super.key});

  @override
  _HedefScreenState createState() => _HedefScreenState();
}

class _HedefScreenState extends State<HedefScreen> {
  final GoogleAds _googleAds = GoogleAds();

  @override
  void initState() {
    super.initState();
    _googleAds.loadBannerAd();
    final portfolioProvider =
        Provider.of<PortfolioProvider>(context, listen: false);
    portfolioProvider.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text(
            'Geçmiş İşlemlerim',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: Column(children: [
          //Ad Banner
          Expanded(
              child: _googleAds.bannerAd == null
                  ? const CircularProgress()
                  : SizedBox(
                      width: _googleAds.bannerAd!.size.width.toDouble(),
                      height: _googleAds.bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _googleAds.bannerAd!),
                    )),
          //Transactions
          Expanded(
            flex: 10,
            child: Consumer<PortfolioProvider>(
                builder: (context, portfolioProvider, child) {
              final allTransactions = portfolioProvider.allTransactions;
              return RefreshIndicator(
                  backgroundColor: HexColor(mainColorLight),
                  color: HexColor(white),
                  onRefresh: () async {
                    await portfolioProvider.loadTransactions();
                  },
                  child: allTransactions.isEmpty
                      ? const Center(
                          child: Text(
                              "Kripto para işlemlerini takip etmeye başla!"),
                        )
                      : ListView.builder(
                          itemCount: allTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = allTransactions[index];
                            final totalAmount =
                                transaction.quantity * transaction.cost;
                            final isBuy = transaction.quantity.isNegative;
                            return ListTile(
                              title: Text(
                                transaction.assetName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                ' ${transaction.quantity.abs()}. adet',
                              ),
                              trailing: Text(
                                isBuy
                                    ? '-${NumberFormat.currency(locale: 'en_US', symbol: '₺').format(totalAmount)}'
                                    : '+${NumberFormat.currency(locale: 'en_US', symbol: '₺').format(totalAmount)}',
                                style: TextStyle(
                                    color: isBuy ? Colors.red : Colors.green,
                                    fontSize: 17),
                              ),
                            );
                          },
                        ));
            }),
          )
        ]));
  }
}
