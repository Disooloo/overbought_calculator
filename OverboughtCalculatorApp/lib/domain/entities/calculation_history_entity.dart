import 'calculation_entity.dart';

class CalculationHistoryEntity {
  final int? id;
  final String name;
  final CalculationEntity calculation;
  final DateTime createdAt;

  const CalculationHistoryEntity({
    this.id,
    required this.name,
    required this.calculation,
    required this.createdAt,
  });

  CalculationHistoryEntity copyWith({
    int? id,
    String? name,
    CalculationEntity? calculation,
    DateTime? createdAt,
  }) {
    return CalculationHistoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      calculation: calculation ?? this.calculation,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

