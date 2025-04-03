import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_data_provider.dart';
import '../widgets/finance/daily_change_card.dart';
import '../widgets/finance/header_section.dart';
import '../widgets/finance/news_card.dart';
import '../widgets/finance/stock_list_item.dart';
import '../widgets/finance/stock_ticker_card.dart';

class FinanceHomeScreen extends StatelessWidget {
  const FinanceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceDataProvider>(
      builder: (context, provider, child) {
        // Calculate the price change for AAPL (or your default stock)
        final aaplStock = provider.stocks.firstWhere(
          (stock) => stock.symbol == 'AAPL',
          orElse: () => provider.stocks.first,
        );
        final priceChange =
            (aaplStock.price * aaplStock.percentageChange / 100);

        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with greeting and search
                  HeaderSection(provider: provider),

                  // Featured news card
                  NewsCard(news: provider.featuredNews),

                  // New stock ticker card (rotating stocks)
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: StockTickerCard(),
                      ),

                      const SizedBox(height: 16),

                      // Daily change card (AAPL focused)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DailyChangeCard(
                          percentageChange: aaplStock.percentageChange,
                          priceChange: priceChange,
                          currentPrice: aaplStock.price,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Stocks list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: StocksList(stocks: provider.stocks),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
