import 'package:flutter/material.dart';

import '../../providers/finance_data_provider.dart';

class HeaderSection extends StatelessWidget {
  final FinanceDataProvider provider;

  const HeaderSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Good Morning,\n${provider.username}',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
