import 'dart:convert';
import 'package:http/http.dart' as http;

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  String? id;
  String? symbol;
  String? name;
  String? image;
  double? currentPrice;
  int? marketCap;
  int? marketCapRank;
  int? fullyDilutedValuation;
  num? totalVolume;
  double? high24H;
  double? low24H;
  double? priceChange24H;
  double? priceChangePercentage24H;
  double? marketCapChange24H;
  double? marketCapChangePercentage24H;
  double? circulatingSupply;
  double? totalSupply;
  double? maxSupply;
  double? ath;
  double? athChangePercentage;
  DateTime? athDate;
  double? atl;
  double? atlChangePercentage;
  DateTime? atlDate;
  Roi? roi;
  DateTime? lastUpdated;

  Post({
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24H,
    this.low24H,
    this.priceChange24H,
    this.priceChangePercentage24H,
    this.marketCapChange24H,
    this.marketCapChangePercentage24H,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.roi,
    this.lastUpdated,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        currentPrice: json["current_price"]?.toDouble(),
        marketCap: json["market_cap"],
        marketCapRank: json["market_cap_rank"],
        fullyDilutedValuation: json["fully_diluted_valuation"],
        totalVolume: json["total_volume"],
        high24H: json["high_24h"]?.toDouble(),
        low24H: json["low_24h"]?.toDouble(),
        priceChange24H: json["price_change_24h"]?.toDouble(),
        priceChangePercentage24H:
            json["price_change_percentage_24h"]?.toDouble(),
        marketCapChange24H: json["market_cap_change_24h"]?.toDouble(),
        marketCapChangePercentage24H:
            json["market_cap_change_percentage_24h"]?.toDouble(),
        circulatingSupply: json["circulating_supply"]?.toDouble(),
        totalSupply: json["total_supply"]?.toDouble(),
        maxSupply: json["max_supply"]?.toDouble(),
        ath: json["ath"]?.toDouble(),
        athChangePercentage: json["ath_change_percentage"]?.toDouble(),
        athDate:
            json["ath_date"] == null ? null : DateTime.parse(json["ath_date"]),
        atl: json["atl"]?.toDouble(),
        atlChangePercentage: json["atl_change_percentage"]?.toDouble(),
        atlDate:
            json["atl_date"] == null ? null : DateTime.parse(json["atl_date"]),
        roi: json["roi"] == null ? null : Roi.fromJson(json["roi"]),
        lastUpdated: json["last_updated"] == null
            ? null
            : DateTime.parse(json["last_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "market_cap": marketCap,
        "market_cap_rank": marketCapRank,
        "fully_diluted_valuation": fullyDilutedValuation,
        "total_volume": totalVolume,
        "high_24h": high24H,
        "low_24h": low24H,
        "price_change_24h": priceChange24H,
        "price_change_percentage_24h": priceChangePercentage24H,
        "market_cap_change_24h": marketCapChange24H,
        "market_cap_change_percentage_24h": marketCapChangePercentage24H,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "max_supply": maxSupply,
        "ath": ath,
        "ath_change_percentage": athChangePercentage,
        "ath_date": athDate?.toIso8601String(),
        "atl": atl,
        "atl_change_percentage": atlChangePercentage,
        "atl_date": atlDate?.toIso8601String(),
        "roi": roi?.toJson(),
        "last_updated": lastUpdated?.toIso8601String(),
      };
}

class Roi {
  double? times;
  String? currency;
  double? percentage;

  Roi({
    this.times,
    this.currency,
    this.percentage,
  });

  factory Roi.fromJson(Map<String, dynamic> json) => Roi(
        times: json["times"]?.toDouble(),
        currency: json["currency"],
        percentage: json["percentage"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "times": times,
        "currency": currency,
        "percentage": percentage,
      };
}

class CoinService {
  Future<Map<DateTime, double>> fetchBitcoinHistoricalPrices(
      DateTime startDate, DateTime endDate) async {
    final url =
        'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart/range'
        '?vs_currency=usd&from=${startDate.millisecondsSinceEpoch / 1000}&to=${endDate.millisecondsSinceEpoch / 1000}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prices = <DateTime, double>{};
      for (var entry in data['prices']) {
        final date = DateTime.fromMillisecondsSinceEpoch(entry[0]);
        prices[date] = entry[1];
      }
      return prices;
    } else {
      throw Exception(
          'Failed to load historical prices ${response.statusCode}');
    }
  }

  Future<List<dynamic>> coinsbyMcap() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=try'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load coin markets ${response.statusCode}');
    }
  }

  Future<List<dynamic>> allCoins() async {
    final response = await http
        .get(Uri.parse('https://api.coingecko.com/api/v3/coins/list'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load all coins ${response.statusCode}');
    }
  }

  Future<Map<String, double>> getCurrentPrices(List<String> assetNames) async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=${assetNames.join(',')}&vs_currencies=try');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value['try'].toDouble()));
    } else {
      throw Exception('Failed to load current prices ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchCoinData() async {
    final url = 'https://api.coingecko.com/api/v3/coins/markets';
    final params = {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': '100',
      'page': '1',
      'price_change_percentage': '24h',
    };
    final uri = Uri.https(url, '', params);

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
    throw Exception('Failed to load coin data ${response.statusCode}');
  }
}
