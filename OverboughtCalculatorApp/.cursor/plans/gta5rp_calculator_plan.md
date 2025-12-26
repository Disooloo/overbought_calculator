# План разработки Flutter приложения "Калькулятор перекупа GTA 5 RP"

## Архитектура

Приложение будет построено на чистой архитектуре с разделением на три слоя:

```
lib/
├── core/              # Общие утилиты, константы, темы
│   └── theme/          # Тёмная тема в стиле GTA RP
├── domain/            # Бизнес-логика
│   ├── entities/       # Сущности (Transaction, Product)
│   └── repositories/  # Интерфейсы репозиториев
├── data/              # Реализация данных
│   ├── models/        # Модели данных
│   ├── repositories/  # Реализация репозиториев
│   └── database/      # SQLite база данных
└── presentation/      # UI слой
    ├── providers/     # Riverpod providers
    ├── screens/       # Экраны
    └── widgets/       # Переиспользуемые виджеты
```

## Основные компоненты

### Domain Layer
- **TransactionEntity**: Сущность операции (сумма, комментарий, дата, тип: доход/расход)
- **ProductEntity**: Сущность товара (название, фото, себестоимость, цена продажи, количество)
- **TransactionRepository**: Интерфейс для работы с операциями
- **ProductRepository**: Интерфейс для работы с товарами

### Data Layer
- **TransactionModel**: Модель данных операции
- **ProductModel**: Модель данных товара
- **AppDatabase**: SQLite база данных с таблицами:
  - `transactions` (id, amount, comment, created_at)
  - `products` (id, name, image_path, cost_price, sale_price, quantity)
- **TransactionRepositoryImpl**: Реализация репозитория операций
- **ProductRepositoryImpl**: Реализация репозитория товаров

### Presentation Layer
- **HomeScreen**: Главный экран с калькулятором
- **FavoritesScreen**: Экран управления товарами
- **TransactionProvider**: Riverpod provider для операций
- **ProductProvider**: Riverpod provider для товаров
- **BalanceProvider**: Provider для расчёта баланса

## Функциональность

### Главный экран
1. **Ввод операции**:
   - Поле ввода суммы (поддержка +/-)
   - Поле комментария
   - Кнопка добавления

2. **Блок итоговых значений**:
   - Заработано (сумма положительных операций) - зелёный
   - Потрачено (сумма отрицательных операций) - красный
   - Баланс (заработано - потрачено) - зелёный/красный

3. **История операций**:
   - Список всех операций
   - Отображение: сумма, комментарий, дата/время
   - Кнопка удаления для каждой записи

### Раздел "Избранное" (товары)
1. **Добавление товара**:
   - Название товара
   - Фото (камера/галерея)
   - Себестоимость
   - Цена продажи
   - Количество (опционально)

2. **Управление товаром**:
   - Отображение списка товаров
   - Кнопки действий:
     - Продать (все)
     - Продать часть (ввод количества)
     - Аннулировать (удалить без учёта прибыли)

3. **Логика продажи**:
   - Прибыль = (цена_продажи - себестоимость) * количество
   - Автоматическое добавление в "Заработано"
   - Запись в историю операций

## Зависимости

Основные пакеты:
- `flutter_riverpod` - State management (уже установлен)
- `sqflite` - SQLite база данных (уже установлен)
- `image_picker` - Работа с камерой/галереей
- `path_provider` - Пути для сохранения фото (уже установлен)
- `intl` - Форматирование дат/чисел (уже установлен)
- `shared_preferences` - Дополнительное хранилище (уже установлен)

## Структура базы данных

### Таблица `transactions`:
- `id` (INTEGER PRIMARY KEY)
- `amount` (REAL) - Сумма (положительная/отрицательная)
- `comment` (TEXT)
- `created_at` (INTEGER) - Timestamp
- `type` (TEXT) - 'manual' или 'product_sale'

### Таблица `products`:
- `id` (INTEGER PRIMARY KEY)
- `name` (TEXT)
- `image_path` (TEXT) - Путь к фото
- `cost_price` (REAL) - Себестоимость
- `sale_price` (REAL) - Цена продажи
- `quantity` (REAL) - Количество
- `created_at` (INTEGER) - Timestamp

## UI/UX особенности

1. **Тёмная тема в стиле GTA RP**:
   - Тёмный фон
   - Яркие акценты (зелёный/красный)
   - Крупные элементы управления

2. **Навигация**:
   - Bottom navigation bar (Главная / Избранное)
   - Или кнопка перехода в раздел избранного

3. **Быстрый ввод**:
   - Крупные поля ввода
   - Минимум кликов
   - Быстрая реакция

## Файловая структура

Ключевые файлы для создания:
- `lib/main.dart` - Точка входа
- `lib/core/theme/gta_theme.dart` - Тема GTA RP
- `lib/domain/entities/transaction_entity.dart`
- `lib/domain/entities/product_entity.dart`
- `lib/data/database/app_database.dart` - Обновить для новых таблиц
- `lib/presentation/providers/transaction_provider.dart`
- `lib/presentation/providers/product_provider.dart`
- `lib/presentation/providers/balance_provider.dart`
- `lib/presentation/screens/home_screen.dart`
- `lib/presentation/screens/favorites_screen.dart`
- `lib/presentation/widgets/transaction_item.dart`
- `lib/presentation/widgets/product_card.dart`
- `lib/presentation/widgets/balance_card.dart`
- `lib/presentation/widgets/add_product_dialog.dart`

