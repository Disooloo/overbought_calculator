import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/balance_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final formatter = NumberFormat('#,###.##');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF0D0D0D),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Заработано
            _buildBalanceItem(
              context,
              Icons.trending_up,
              'Заработано',
              formatter.format(balance.earned),
              Colors.green,
            ),
            const SizedBox(height: 16),
            // Потрачено
            _buildBalanceItem(
              context,
              Icons.trending_down,
              'Потрачено',
              formatter.format(balance.spent),
              Colors.red,
            ),
            const Divider(
              color: Color(0xFF333333),
              thickness: 1,
              height: 24,
            ),
            // Баланс
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (balance.balance >= 0 ? Colors.green : Colors.red)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (balance.balance >= 0 ? Colors.green : Colors.red)
                      .withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        balance.balance >= 0 ? Icons.account_balance_wallet : Icons.warning,
                        color: balance.balance >= 0 ? Colors.green : Colors.red,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Баланс',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Text(
                    formatter.format(balance.balance),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: balance.balance >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
