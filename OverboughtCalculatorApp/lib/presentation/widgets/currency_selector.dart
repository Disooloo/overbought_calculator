import 'package:flutter/material.dart';
import '../../domain/entities/calculation_entity.dart';

class CurrencySelector extends StatelessWidget {
  final Currency selectedCurrency;
  final ValueChanged<Currency> onChanged;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Currency>(
      segments: [
        ButtonSegment<Currency>(
          value: Currency.rub,
          label: Text(Currency.rub.symbol),
          tooltip: 'Рубли',
        ),
        ButtonSegment<Currency>(
          value: Currency.usd,
          label: Text(Currency.usd.symbol),
          tooltip: 'Доллары',
        ),
        ButtonSegment<Currency>(
          value: Currency.eur,
          label: Text(Currency.eur.symbol),
          tooltip: 'Евро',
        ),
      ],
      selected: {selectedCurrency},
      onSelectionChanged: (Set<Currency> newSelection) {
        onChanged(newSelection.first);
      },
    );
  }
}

