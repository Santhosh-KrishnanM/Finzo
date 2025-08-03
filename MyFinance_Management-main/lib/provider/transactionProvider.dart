import 'dart:async';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  // Use final for the list that will be mutated but not reassigned
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'title': 'Lunch',
      'category': 'Food',
      'type': 'Expense',
      'amount': 20.0,
      'date': '2024-03-15',
      'description': 'Lunch at cafe',
    },
    {
      'id': '2',
      'title': 'Salary',
      'category': 'Salary',
      'type': 'Income',
      'amount': 3000.0,
      'date': '2024-03-01',
      'description': 'Monthly salary',
    },
    {
      'id': '3',
      'title': 'Groceries',
      'category': 'Food',
      'type': 'Expense',
      'amount': 50.0,
      'date': '2024-02-10',
      'description': 'Weekly groceries',
    },
  ];

  // StreamController to emit transaction list updates, broadcast allows multiple subscribers
  final StreamController<List<Map<String, dynamic>>> _transactionsController =
      StreamController.broadcast();

  // Getter to expose the transaction stream
  Stream<List<Map<String, dynamic>>> get transactionsStream {
    // Emit the current transactions list
    _transactionsController.add(List.unmodifiable(_transactions));
    return _transactionsController.stream;
  }

  // Add a new transaction and notify listeners & stream subscribers
  void addTransaction(Map<String, dynamic> transaction) {
    _transactions.add(transaction);
    _transactionsController.add(List.unmodifiable(_transactions));
    notifyListeners();
  }

  // Delete a transaction by id and update stream & listeners
  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t['id'] == id);
    _transactionsController.add(List.unmodifiable(_transactions));
    notifyListeners();
  }

  // Get list of unique categories from transactions
  List<String> getCategories() {
    final categories = <String>{};
    for (var t in _transactions) {
      categories.add(t['category'] ?? 'Uncategorized');
    }
    return categories.toList();
  }

  // Compute total for a given category and month (month as String '1' - '12')
  double getHistoricalValue({required String category, required String month}) {
    double total = 0.0;
    for (var transaction in _transactions) {
      final date = DateTime.tryParse(transaction['date']);
      if (date != null &&
          transaction['category'] == category &&
          date.month.toString() == month) {
        total += (transaction['amount'] as num).toDouble();
      }
    }
    return total;
  }

  // Show dialog for adding or editing a transaction
  Future<void> showTransactionDialog(BuildContext context, {String? id}) async {
    final isEditing = id != null;
    Map<String, dynamic>? transaction;

    if (isEditing) {
      transaction = _transactions.firstWhere((t) => t['id'] == id);
    }

    final titleController =
        TextEditingController(text: isEditing ? transaction!['title'] : '');
    final amountController = TextEditingController(
        text: isEditing ? transaction!['amount'].toString() : '');
    String? selectedCategory = isEditing ? transaction!['category'] : null;
    String type = isEditing ? transaction!['type'] : 'Expense';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCategory,
                      hint: const Text('Select Category'),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: getCategories().map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Type:'),
                        DropdownButton<String>(
                          value: type,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                type = newValue;
                              });
                            }
                          },
                          items: ['Income', 'Expense'].map((t) {
                            return DropdownMenuItem(
                              value: t,
                              child: Text(t),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount == null ||
                    selectedCategory == null ||
                    titleController.text.trim().isEmpty) {
                  // Could show validation error here
                  return;
                }

                final newTransaction = {
                  'id': isEditing
                      ? id!
                      : DateTime.now().millisecondsSinceEpoch.toString(),
                  'title': titleController.text.trim(),
                  'category': selectedCategory,
                  'type': type,
                  'amount': amount,
                  'date': DateTime.now().toIso8601String(),
                  'description': '',
                };

                if (isEditing) {
                  deleteTransaction(id!);
                }
                addTransaction(newTransaction);
                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _transactionsController.close();
    super.dispose();
  }
}
