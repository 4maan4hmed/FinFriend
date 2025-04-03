import 'package:flutter/material.dart';

import '../../models/stock_item.dart';

class MiniGraph extends StatelessWidget {
  final List<double> points;
  final Color color;

  const MiniGraph({super.key, required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(80, 40),
      painter: _MiniGraphPainter(points: points, color: color),
    );
  }
}

class _MiniGraphPainter extends CustomPainter {//TODO::Make this a seperate widget
  final List<double> points;
  final Color color;

  _MiniGraphPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (points.isEmpty) return;

    final path = Path();
    final width = size.width / (points.length - 1);
    final max = points.reduce((a, b) => a > b ? a : b);
    final min = points.reduce((a, b) => a < b ? a : b);
    final range = max - min;

    path.moveTo(0, size.height * (1 - (points[0] - min) / range));
    for (var i = 1; i < points.length; i++) {
      path.lineTo(
        width * i,
        size.height * (1 - (points[i] - min) / range),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StockListItem extends StatelessWidget {
  final StockItem stock;

  const StockListItem({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.percentageChange >= 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                stock.symbol.substring(0, 1),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  stock.name,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            height: 40,
            child: MiniGraph(
              points: stock.graphPoints,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${stock.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${stock.percentageChange.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StocksList extends StatelessWidget {
  final List<StockItem> stocks;

  const StocksList({super.key, required this.stocks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Stocks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: stocks.length,
            separatorBuilder: (context, index) => const Divider(height: 16),
            itemBuilder: (context, index) {
              return StockListItem(stock: stocks[index]);
            },
          ),
        ],
      ),
    );
  }
}
