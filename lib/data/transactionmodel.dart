class Transaction {
  final int id;
  final String assetName;
  final String type;
  final double cost;
  final double quantity;
  final String date;

  Transaction({
    required this.id,
    required this.assetName,
    required this.type,
    required this.cost,
    required this.quantity,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      assetName: json['asset_name'],
      type: json['type'],
      cost: json['cost'],
      quantity: json['quantity'],
      date: json['date'],
    );
  }
}
