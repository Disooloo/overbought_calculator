import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/calculation_entity.dart';

class ResultCard extends StatelessWidget {
  final CalculationEntity calculation;

  const ResultCard({
    super.key,
    required this.calculation,
  });

  String _formatCurrency(double value) {
    final formatter = NumberFormat('#,###.##');
    return '${calculation.currency.symbol} ${formatter.format(value)}';
  }

  String _formatPercent(double value) {
    final formatter = NumberFormat('#,##0.00');
    return '${formatter.format(value)}%';
  }

  @override
  Widget build(BuildContext context) {
    final isProfit = calculation.isProfit;
    final profitColor = isProfit ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Результаты расчёта',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildResultRow(
              context,
              'Общие расходы',
              _formatCurrency(calculation.totalExpenses),
            ),
            _buildResultRow(
              context,
              'Инвестиции',
              _formatCurrency(calculation.investments),
            ),
            const Divider(),
            _buildResultRow(
              context,
              'Чистая прибыль',
              _formatCurrency(calculation.profit),
              valueColor: profitColor,
              isBold: true,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildResultRow(
                    context,
                    'Маржа',
                    _formatPercent(calculation.margin),
                    valueColor: profitColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResultRow(
                    context,
                    'ROI',
                    _formatPercent(calculation.roi),
                    valueColor: profitColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              context,
              'Точка безубыточности',
              _formatCurrency(calculation.breakEvenPoint),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isProfit
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: profitColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isProfit ? Icons.trending_up : Icons.trending_down,
                    color: profitColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isProfit ? 'Прибыль' : 'Убыток',
                    style: TextStyle(
                      color: profitColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: valueColor,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}

