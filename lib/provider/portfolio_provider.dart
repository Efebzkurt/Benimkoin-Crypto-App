import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:benimkoin/components/selectionbox/selectionbox.dart';
import 'package:benimkoin/data/coin_service.dart';
import 'package:benimkoin/data/dbhelper.dart';
import 'package:benimkoin/data/transactionmodel.dart';

class PortfolioProvider extends ChangeNotifier {
  final CoinService _coinService = CoinService();
  final Map<SelectionBoxDataTime, Map<DateTime, double>> _cachedBitcoinPrices =
      {};

  Map<DateTime, double> _bitcoinPriceHistory = {};
  double _totalValue = 0.0;
  List<Transaction> _allTransactions = [];
  Map<String, double> _currentPrices = {};
  List<Map<String, dynamic>> _portfolio = [];

  Map<DateTime, double> get bitcoinPriceHistory => _bitcoinPriceHistory;
  double get totalValue => _totalValue;
  Map<String, double> get currentPrices => _currentPrices;
  List<Map<String, dynamic>> get portfolio => _portfolio;
  List<Transaction> get allTransactions => _allTransactions;
  final dbHelper = PortfolioDatabase.instance;

  Future<void> fetchHistoricalData(SelectionBoxDataTime selectedTime) async {
    if (_cachedBitcoinPrices.containsKey(selectedTime)) {
      _bitcoinPriceHistory = _cachedBitcoinPrices[selectedTime]!;
    } else {
      int days;
      switch (selectedTime) {
        case SelectionBoxDataTime.time1:
          days = 1; // 1 day for 24 hours
          break;
        case SelectionBoxDataTime.time2:
          days = 7;
          break;
        case SelectionBoxDataTime.time3:
          days = 30;
          break;
        case SelectionBoxDataTime.time4:
          days = 90;
          break;
        case SelectionBoxDataTime.time5:
          days = 365;
          break;
        case SelectionBoxDataTime.all:
        default:
          days = 365;
          break;
      }

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: days));

      try {
        _bitcoinPriceHistory =
            await _coinService.fetchBitcoinHistoricalPrices(startDate, endDate);
        _cachedBitcoinPrices[selectedTime] =
            _bitcoinPriceHistory; // Cache the fetched data
      } catch (e) {
        print('Failed to fetch Bitcoin historical prices: $e');
      }
    }

    notifyListeners();
  }

  Future<void> loadTransactions() async {
    try {
      final transactions = await dbHelper.getAllTransactions();
      _allTransactions =
          transactions.map((json) => Transaction.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Failed to load transactions: $e');
    }
  }

  Future<void> loadAssets() async {
    _portfolio = await dbHelper.getPortfolio();
    final assets = _portfolio.map((item) => item.toString()).toList();
    notifyListeners();
  }

  Future<void> calculateTotalValue() async {
    _portfolio = await dbHelper.getPortfolio();
    final assetNames =
        _portfolio.map((item) => item['name'].toString()).toList();
    _currentPrices = await _coinService.getCurrentPrices(assetNames);

    _totalValue = 0.0;
    for (var asset in _portfolio) {
      final String name = asset['name'].toString();
      final quantity = asset['quantity'];
      final double currentPrice = _currentPrices[name.toLowerCase()] ?? 0;
      _totalValue += quantity * currentPrice;
    }
    notifyListeners();
  }

  Future<void> addAsset(String name, double cost, double quantity) async {
    await dbHelper.addAsset(name, cost, quantity);
    await calculateTotalValue();
    notifyListeners();
  }

  Future<void> removeAsset(int assetId) async {
    await dbHelper.deleteRowsWithZeroQuantity();
    await calculateTotalValue();
    notifyListeners();
  }

  Future<void> updateCurrentPrices() async {
    final assetNames =
        _portfolio.map((item) => item['name'].toString()).toList();
    _currentPrices = await _coinService.getCurrentPrices(assetNames);
    await calculateTotalValue();
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchCoinData() async {
    const url = 'api.coingecko.com';
    const endpoint = '/api/v3/coins/markets';
    final params = {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': '100',
      'page': '1',
      'price_change_percentage': '24h',
    };

    final uri = Uri.https(url, endpoint, params);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final bitcoin = data.firstWhere((coin) => coin['id'] == 'bitcoin');
        final topGainer = data.reduce((a, b) =>
            a['price_change_percentage_24h'] > b['price_change_percentage_24h']
                ? a
                : b);
        final topLoser = data.reduce((a, b) =>
            a['price_change_percentage_24h'] < b['price_change_percentage_24h']
                ? a
                : b);

        return {
          'bitcoin': bitcoin,
          'topGainer': topGainer,
          'topLoser': topLoser,
        };
      }
    }
    throw Exception('Failed to load coin data');
  }
}
