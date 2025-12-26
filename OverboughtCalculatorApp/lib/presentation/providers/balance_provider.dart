import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_provider.dart';

class BalanceState {
  final double earned; // Заработано
  final double spent; // Потрачено
  final double balance; // Баланс

  const BalanceState({
    this.earned = 0,
    this.spent = 0,
    this.balance = 0,
  });
}

final balanceProvider = Provider<BalanceState>((ref) {
  final transactionsAsync = ref.watch(transactionProvider);

  return transactionsAsync.when(
    data: (transactions) {
      double earned = 0;
      double spent = 0;

      for (final transaction in transactions) {
        if (transaction.amount > 0) {
          earned += transaction.amount;
        } else {
          spent += transaction.amount.abs();
        }
      }

      return BalanceState(
        earned: earned,
        spent: spent,
        balance: earned - spent,
      );
    },
    loading: () => const BalanceState(),
    error: (_, __) => const BalanceState(),
  );
});

