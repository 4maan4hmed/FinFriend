class StockItem {
  final String symbol;
  final String name;
  final double price;
  final double percentageChange;
  final List<double> graphPoints;

  StockItem({
    required this.symbol,
    required this.name,
    required this.price,
    required this.percentageChange,
    required this.graphPoints,
  });
}
